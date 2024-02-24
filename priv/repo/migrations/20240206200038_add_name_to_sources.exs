defmodule Bec.Repo.Migrations.AddNameToSources do
  use Ecto.Migration

  def up do
    alter table(:sources, prefix: "_beamecho") do
      add(:name, :string, null: false)
    end
  end

  def down do
    alter table(:sources, prefix: "_beamecho") do
      remove(:name)
    end
  end
end
