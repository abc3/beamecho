defmodule BecWeb.AppJSON do
  alias Bec.Api.App

  @doc """
  Renders a list of app.
  """
  def index(%{app: app}) do
    %{data: for(app <- app, do: data(app))}
  end

  @doc """
  Renders a single app.
  """
  def show(%{app: app}) do
    %{data: data(app)}
  end

  defp data(%App{} = app) do
    %{
      id: app.id,
      name: app.name,
      type: app.type,
      key_file: app.key_file,
      key_id: app.key_id,
      team_id: app.team_id,
      app_bundle_id: app.app_bundle_id
    }
  end
end
