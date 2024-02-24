defmodule Bec.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Bec.Apps},
      {Registry, keys: :unique, name: Bec.Registry.JobHandlers},
      BecWeb.Telemetry,
      Bec.Repo,
      {Phoenix.PubSub, name: Bec.PubSub},
      {Finch, name: Bec.Finch},
      BecWeb.Endpoint,
      Bec.Vault,
      {Bec.JobChecker, %{interval: Application.get_env(:beamecho, :check_queue_interval)}},
      {
        PartitionSupervisor,
        child_spec: DynamicSupervisor, strategy: :one_for_one, name: Bec.DynamicSupervisor
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bec.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BecWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
