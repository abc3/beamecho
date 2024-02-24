defmodule Bec.Repo.Migrations.AddDeviceTokenToHandlers do
  use Ecto.Migration

  def up do
    alter table(:handlers, prefix: "_beamecho") do
      add(:device_token, :string, null: false)
    end
  end

  def down do
    alter table(:handlers, prefix: "_beamecho") do
      remove(:device_token)
    end
  end
end
