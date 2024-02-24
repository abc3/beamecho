defmodule Bec.Repo do
  use Ecto.Repo,
    otp_app: :beamecho,
    adapter: Ecto.Adapters.Postgres
end
