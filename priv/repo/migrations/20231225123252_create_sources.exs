defmodule Bec.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources, primary_key: false, prefix: "_beamecho") do
      add :id, :binary_id, primary_key: true
      add :host, :string
      add :dbname, :string
      add :dbuser, :string
      add :dbpass_encrypted, :binary, null: false
      add :dbport, :integer
      add :use_ssl, :boolean, default: false, null: false
      add :ip_version, :string, null: false, default: "v4"

      timestamps()
    end
  end
end
