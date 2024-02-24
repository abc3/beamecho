defmodule Bec.Repo.Migrations.AddNameToApps do
  use Ecto.Migration

  def up do
    alter table(:apps, prefix: "_beamecho") do
      add(:name, :string, null: false)
    end
  end

  def down do
    alter table(:apps, prefix: "_beamecho") do
      remove(:name)
    end
  end
end
