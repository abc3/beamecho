defmodule Bec do
  @moduledoc false
  require Logger
  alias Bec.Api

  def add_new_job(handler_id) do
    Api.create_job(%{
      handler_id: handler_id,
      status: "waiting",
      started_at: DateTime.utc_now()
    })
  end

  def start_job(id) do
    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {Bec.DynamicSupervisor, id}},
      {Bec.JobHandler, %{id: id}}
    )
  end

  def start_apns2(opts) do
    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {Bec.DynamicSupervisor, opts[:name]}},
      {Pigeon.Dispatcher, opts}
    )
  end
end
