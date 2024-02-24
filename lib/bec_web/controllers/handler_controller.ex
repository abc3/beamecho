defmodule BecWeb.HandlerController do
  use BecWeb, :controller

  require Logger
  alias Bec.Api
  alias Bec.Api.Handler
  alias Bec.Repo

  action_fallback BecWeb.FallbackController

  def index(conn, _params) do
    handlers = Api.list_handlers()
    render(conn, :index, handlers: handlers)
  end

  def create(conn, %{"handler" => handler_params}) do
    with {:ok, %Handler{} = handler} <- Api.create_handler(handler_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/handlers/#{handler}")
      |> render(:show, handler: handler)
    end
  end

  def show(conn, %{"id" => id}) do
    handler = Api.get_handler!(id)
    render(conn, :show, handler: handler)
  end

  def send(conn, %{"id" => id}) do
    Logger.info("Sending handler #{id}")

    handler =
      Api.get_handler!(id)
      |> Repo.preload([:app, :source])

    Bec.push(handler)

    # Repo.all(
    #   from(h in Handler,
    #     where: h.id == ^id
    #     # preload: [:app, :source]
    #   )
    # )

    # case Ecto.Adapters.SQL.query(Repo, handler.query, []) do
    #   {:ok, %{columns: columns, rows: rows}} when rows > 0 ->
    #     for row <- rows do
    #       record = Enum.zip(columns, row) |> Enum.into(%{})
    #       {:ok, template} = Solid.parse(handler.template)
    #       payload = Solid.render!(template, record) |> to_string |> Jason.decode!()

    #       Pigeon.APNS.push(%Pigeon.APNS.Notification{
    #         collapse_id: nil,
    #         device_token: record["device_token"],
    #         expiration: nil,
    #         priority: nil,
    #         push_type: "alert",
    #         id: nil,
    #         payload: payload,
    #         topic: "dev.abc3.testApns",
    #         response: nil
    #       })
    #     end

    #   _ ->
    #     nil
    # end

    render(conn, :show, handler: handler)
  end

  def update(conn, %{"id" => id, "handler" => handler_params} = q) do
    handler = Api.get_handler!(id)

    with {:ok, %Handler{} = handler} <- Api.update_handler(handler, handler_params) do
      render(conn, :show, handler: handler)
    end
  end

  def delete(conn, %{"id" => id}) do
    handler = Api.get_handler!(id)

    with {:ok, %Handler{}} <- Api.delete_handler(handler) do
      send_resp(conn, :no_content, "")
    end
  end

  def source_query(conn, %{"source_query" => %{"source_id" => id, "query" => query}}) do
    source = Api.get_source!(id)

    {:ok, pid} =
      Postgrex.start_link(
        hostname: source.host,
        port: source.dbport,
        database: source.dbname,
        username: source.dbuser,
        password: source.dbpass,
        pool_size: 1
      )

    case Postgrex.query(pid, query, []) do
      {:ok, %{columns: columns}} ->
        GenServer.stop(pid, :normal)
        render(conn, :source_query, columns: columns)

      other ->
        Logger.error("Query failed: #{inspect(other)}")
        GenServer.stop(pid, :normal)
        render(conn, :source_query, error: inspect(other))
    end
  end
end
