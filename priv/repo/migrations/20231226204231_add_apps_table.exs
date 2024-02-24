defmodule Bec.Repo.Migrations.AddAppsTable do
  use Ecto.Migration

  def change do
    create table(:apps, primary_key: false, prefix: "_beamecho") do
      add :id, :binary_id, primary_key: true
      add :type, :string, null: false, default: "auth_key"
      add :key_file, :text
      add :key_id, :string
      add :team_id, :string
      add :app_bundle_id, :string

      timestamps()
    end
  end
end
