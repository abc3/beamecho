defmodule Bec.Api.Source do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @schema_prefix "_beamecho"

  schema "sources" do
    field :name, :string
    field :host, :string
    field :dbname, :string
    field :dbuser, :string
    # field :dbpass, :string
    field :dbpass, Bec.Encrypted.Binary, source: :dbpass_encrypted
    field :dbport, :integer
    field :use_ssl, :boolean, default: false
    field :ip_version, Ecto.Enum, values: [:v4, :v6], default: :v4

    timestamps()
  end

  @doc false
  def changeset(source, attrs) do
    source
    |> cast(attrs, [:name, :host, :dbname, :dbuser, :dbpass, :dbport, :use_ssl, :ip_version])
    |> validate_required([:name, :host, :dbname, :dbuser, :dbpass, :dbport])
  end
end
