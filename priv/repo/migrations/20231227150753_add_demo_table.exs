defmodule Bec.Repo.Migrations.AddDemoTable do
  use Ecto.Migration

  def change do
    create table(:demo_table, prefix: "_beamecho") do
      add :username, :string
      add :device_token, :string
      add :current_level, :integer
      add :last_visit, :naive_datetime

      timestamps()
    end
  end
end
