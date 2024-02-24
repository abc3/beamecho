defmodule Bec.JobChecker do
  @moduledoc false
  require Logger
  use GenServer

  alias Bec.Api

  def start_link(args), do: GenServer.start_link(__MODULE__, args, name: __MODULE__)

  @impl true
  def init(args) do
    Logger.info("Starting JobChecker, interval: #{args.interval}")

    state = %{
      ref: check(0),
      interval: args.interval
    }

    {:ok, state}
  end

  @impl true
  def handle_info(:check_queue, state) do
    Process.cancel_timer(state.ref)

    Logger.debug("Checking queue")

    for job <- Api.list_waiting_jobs() do
      Logger.info("Starting job #{job.id}")
      Bec.JobHandler.update_job(job.id, %{status: "scheduled"})
      Bec.JobHandler.start(job.id)
    end

    Logger.debug("Done checking queue")
    {:noreply, %{state | ref: check(state.interval)}}
  end

  ### Internal functions
  defp check(interval) do
    Logger.debug("Checking queue after #{interval}ms")
    Process.send_after(self(), :check_queue, interval)
  end
end
