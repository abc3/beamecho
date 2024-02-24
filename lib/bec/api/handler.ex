defmodule Bec.Api.Handler do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bec.Api.{Source, App}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @schema_prefix "_beamecho"

  schema "handlers" do
    field :active, :boolean, default: false
    field :name, :string
    field :check_type, Ecto.Enum, values: [:interval], default: :interval
    field :template, :string
    field :query, :string
    field :check_interval, :integer
    field :device_token, :string
    # field :app_id, :binary_id
    # field :source_id, :binary_id

    belongs_to(:source, Source)
    belongs_to(:app, App)

    timestamps()
  end

  @doc false
  def changeset(handler, attrs) do
    handler
    |> cast(attrs, [
      :name,
      :query,
      :template,
      :active,
      :check_type,
      :check_interval,
      :app_id,
      :source_id,
      :device_token
    ])
    |> validate_required([:name, :query, :template, :device_token])
  end
end
