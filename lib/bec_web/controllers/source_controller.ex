defmodule BecWeb.SourceController do
  use BecWeb, :controller

  alias Bec.Api
  alias Bec.Api.Source

  action_fallback BecWeb.FallbackController

  def index(conn, _params) do
    sources = Api.list_sources()
    render(conn, :index, sources: sources)
  end

  def create(conn, %{"source" => source_params}) do
    with {:ok, %Source{} = source} <- Api.create_source(source_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/sources/#{source}")
      |> render(:show, source: source)
    end
  end

  def show(conn, %{"id" => id}) do
    # :timer.sleep(1000)
    source = Api.get_source!(id)
    render(conn, :show, source: source)
  end

  def update(conn, %{"id" => id, "source" => source_params}) do
    source = Api.get_source!(id)

    with {:ok, %Source{} = source} <- Api.update_source(source, source_params) do
      render(conn, :show, source: source)
    end
  end

  def delete(conn, %{"id" => id}) do
    source = Api.get_source!(id)

    with {:ok, %Source{}} <- Api.delete_source(source) do
      send_resp(conn, :no_content, "")
    end
  end
end
