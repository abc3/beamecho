defmodule BecWeb.HandlerJSON do
  alias Bec.Api.Handler

  @doc """
  Renders a list of handlers.
  """
  def index(%{handlers: handlers}) do
    %{data: for(handler <- handlers, do: data(handler))}
  end

  @doc """
  Renders a single handler.
  """

  def source_query(%{columns: columns}) do
    %{data: columns}
  end

  def source_query(%{error: msg}) do
    %{error: msg}
  end

  def show(%{handler: handler}) do
    %{data: data_one(handler)}
  end

  defp data_one(%Handler{} = handler) do
    %{
      id: handler.id,
      name: handler.name,
      query: handler.query,
      template: handler.template,
      active: handler.active,
      check_type: handler.check_type,
      check_interval: handler.check_interval,
      app_id: handler.app_id,
      source_id: handler.source_id,
      device_token: handler.device_token
    }
  end

  defp data(%Handler{} = handler) do
    %{
      id: handler.id,
      name: handler.name,
      query: handler.query,
      template: handler.template,
      active: handler.active,
      check_type: handler.check_type,
      check_interval: handler.check_interval,
      app_id: handler.app_id,
      source_id: handler.source_id,
      inserted_at: handler.inserted_at
    }
    |> Map.put(:app, %{id: handler.app.id, name: handler.app.app_bundle_id})
    |> Map.put(:source, %{
      id: handler.source.id,
      name: handler.source.name
    })
  end
end
