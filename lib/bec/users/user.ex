defmodule Bec.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  @schema_prefix "_beamecho"

  schema "users" do
    pow_user_fields()

    timestamps()
  end
end
