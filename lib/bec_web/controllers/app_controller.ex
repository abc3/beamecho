defmodule BecWeb.AppController do
  use BecWeb, :controller

  alias Bec.Api
  alias Bec.Api.App

  action_fallback BecWeb.FallbackController

  def index(conn, _params) do
    app = Api.list_app()
    render(conn, :index, app: app)
  end

  def create(conn, %{"app" => app_params}) do
    app_params =
      case String.split(app_params["key_file"], "base64,") do
        [_, key_file] -> %{app_params | "key_file" => Base.decode64!(key_file)}
        _ -> app_params
      end

    with {:ok, %App{} = app} <- Api.create_app(app_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/app/#{app}")
      |> render(:show, app: app)
    end
  end

  def show(conn, %{"id" => id}) do
    app = Api.get_app!(id)
    render(conn, :show, app: app)
  end

  def update(conn, %{"id" => id, "app" => app_params}) do
    app_params =
      case String.split(app_params["key_file"], "base64,") do
        [_, key_file] -> %{app_params | "key_file" => Base.decode64!(key_file)}
        _ -> app_params
      end

    app = Api.get_app!(id)

    with {:ok, %App{} = app} <- Api.update_app(app, app_params) do
      render(conn, :show, app: app)
    end
  end

  def delete(conn, %{"id" => id}) do
    app = Api.get_app!(id)

    with {:ok, %App{}} <- Api.delete_app(app) do
      send_resp(conn, :no_content, "")
    end
  end
end
