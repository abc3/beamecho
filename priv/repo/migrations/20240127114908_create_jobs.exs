defmodule Bec.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false, prefix: "_beamecho") do
      add :id, :binary_id, primary_key: true
      add :status, :string
      add :sent_success, :integer
      add :sent_failed, :integer
      add :callback, :text
      add :started_at, :naive_datetime
      add :finished_at, :naive_datetime
      add :handler_id, references(:handlers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:jobs, [:handler_id], prefix: "_beamecho")
  end
end
