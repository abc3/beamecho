defmodule Bec.Api.App do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @schema_prefix "_beamecho"

  schema "apps" do
    field :type, Ecto.Enum, values: [:auth_key], default: :auth_key
    field :name, :string
    field :team_id, :string
    field :key_id, :string
    field :key_file, :string
    field :app_bundle_id, :string

    timestamps()
  end

  @doc false
  def changeset(app, attrs) do
    app
    |> cast(attrs, [:type, :key_file, :key_id, :team_id, :app_bundle_id, :name])
    |> validate_required([:name, :key_file, :key_id, :team_id, :app_bundle_id])
  end
end
