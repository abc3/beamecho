defmodule BecWeb.JobJSON do
  alias Bec.Api.Job

  @doc """
  Renders a list of jobs.
  """
  def index(%{jobs: jobs}) do
    %{data: for(job <- jobs, do: data(job))}
  end

  @doc """
  Renders a single job.
  """
  def show(%{job: job}) do
    %{data: data(job)}
  end

  def add(%{resp: resp}) do
    %{data: inspect(resp)}
  end

  def restart(%{resp: resp}) do
    %{data: inspect(resp)}
  end

  def cancel(%{resp: resp}) do
    %{data: inspect(resp)}
  end

  defp data(%Job{} = job) do
    %{
      id: job.id,
      status: job.status,
      sent_success: job.sent_success,
      sent_failed: job.sent_failed,
      callback: job.callback,
      started_at: job.started_at,
      finished_at: job.finished_at,
      handler: %{id: job.handler.id, name: job.handler.name}
    }
  end
end
