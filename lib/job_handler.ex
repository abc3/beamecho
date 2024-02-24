defmodule Bec.JobHandler do
  @moduledoc false
  require Logger
  use GenServer

  alias Bec.Api
  alias Postgrex, as: P

  def start_link(args) do
    name = {:via, Registry, {Bec.Registry.JobHandlers, job_handler: args.id}}
    GenServer.start_link(__MODULE__, args, name: name)
  end

  def start(id) do
    start_link(%{id: id})
  end

  def stop(id) do
    {:via, Registry, {Bec.Registry.JobHandlers, job_handler: id}}
    |> GenServer.stop()
  end

  @impl true
  def init(args) do
    Process.flag(:trap_exit, true)

    state = %{
      id: args.id,
      source: nil,
      sent: %{success: 0, failed: 0}
    }

    update_job(args.id, %{status: "running", started_at: DateTime.utc_now()})

    {:ok, state, {:continue, :handle}}
  end

  @impl true
  def handle_continue(:handle, state) do
    job = Api.get_job!(state.id)
    handler = Api.get_handler(job.handler_id)
    app = handler.app
    {:ok, conn} = connect_to_source(handler.source)

    case P.query(conn, handler.query, []) do
      {:ok, result} ->
        Logger.debug("Query result: #{inspect(result)}")

        name = {:via, Registry, {Bec.Apps, app.id}}

        opts = [
          adapter: Pigeon.APNS,
          key_identifier: app.key_id,
          key: app.key_file,
          team_id: app.team_id,
          mode: :dev,
          name: name
        ]

        Bec.start_apns2(opts)

        sent_status =
          for row <- result.rows, reduce: state.sent do
            acc ->
              record = Enum.zip(result.columns, row) |> Enum.into(%{})
              {:ok, template} = Solid.parse(handler.template)

              payload = Solid.render!(template, record) |> to_string |> Jason.decode!()

              msg = message(payload, record["device_token"])
              res = Pigeon.push(name, msg)

              case res.response do
                :success ->
                  %{acc | success: acc.success + 1}

                _error ->
                  Logger.error("Failed to send message: #{inspect(res)}")
                  %{acc | failed: acc.failed + 1}
              end
          end

        Logger.info("Sent status: #{inspect(sent_status)}")

        update_job(state.id, %{
          status: "completed",
          sent_success: sent_status.success,
          sent_failed: sent_status.failed,
          finished_at: DateTime.utc_now()
        })

        {:stop, :normal, state}

      {:error, reason} ->
        Logger.error("Query failed: #{inspect(reason)}")
        update_job(state.id, %{status: "failed", finished_at: DateTime.utc_now()})
        {:stop, :normal, state}
    end
  end

  @impl true
  def handle_info({:EXIT, _source, :killed}, state) do
    Logger.error("Job handler died")
    {:stop, :normal, state}
  end

  @impl true
  def terminate(reason, state) do
    Logger.error("Job handler terminated: #{inspect(reason)}")
    # update_job(state.id, %{status: "failed", finished_at: DateTime.utc_now()})
    :ok
  end

  def message(payload, device_token) do
    %Pigeon.APNS.Notification{
      collapse_id: nil,
      device_token: device_token,
      expiration: nil,
      priority: nil,
      push_type: "alert",
      id: nil,
      payload: payload,
      topic: "dev.abc3.testApns",
      response: nil
    }
  end

  def update_job(id, attrs) do
    job = Api.get_job!(id)
    Api.update_job(job, attrs)
  end

  def connect_to_source(source) do
    Postgrex.start_link(
      hostname: source.host,
      port: source.dbport,
      database: source.dbname,
      username: source.dbuser,
      password: source.dbpass,
      pool_size: 1
    )
  end
end
