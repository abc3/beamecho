defmodule Bec.Repo.Migrations.CreateHandlers do
  use Ecto.Migration

  def change do
    create table(:handlers, primary_key: false, prefix: "_beamecho") do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :query, :text
      add :template, :text
      add :active, :boolean, default: false, null: false
      add :check_type, :string
      add :check_interval, :integer
      add :app_id, references(:apps, on_delete: :nothing, type: :binary_id)
      add :source_id, references(:sources, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:handlers, [:app_id], prefix: "_beamecho")
    create index(:handlers, [:source_id], prefix: "_beamecho")
  end
end
