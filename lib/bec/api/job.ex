defmodule Bec.Api.Job do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bec.Api.Handler

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @schema_prefix "_beamecho"

  schema "jobs" do
    field :status, :string
    field :started_at, :naive_datetime
    field :callback, :string
    field :sent_success, :integer
    field :sent_failed, :integer
    field :finished_at, :naive_datetime
    # field :handler_id, :binary_id
    belongs_to(:handler, Handler)

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [
      :handler_id,
      :status,
      :sent_success,
      :sent_failed,
      :callback,
      :started_at,
      :finished_at
    ])

    # |> validate_required([:status, :sent_success, :sent_failed, :callback, :started_at, :finished_at])
  end
end
