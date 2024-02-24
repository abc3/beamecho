defmodule BecWeb.SourceJSON do
  alias Bec.Api.Source

  @doc """
  Renders a list of sources.
  """
  def index(%{sources: sources}) do
    %{data: for(source <- sources, do: data(source))}
  end

  @doc """
  Renders a single source.
  """
  def show(%{source: source}) do
    %{data: data(source)}
  end

  defp data(%Source{} = source) do
    %{
      id: source.id,
      name: source.name,
      host: source.host,
      dbname: source.dbname,
      dbuser: source.dbuser,
      dbpass: source.dbpass,
      dbport: source.dbport,
      use_ssl: source.use_ssl,
      ip_version: source.ip_version
    }
  end
end
