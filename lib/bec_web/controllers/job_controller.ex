defmodule BecWeb.JobController do
  use BecWeb, :controller

  alias Bec.Api
  alias Bec.Api.Job

  action_fallback BecWeb.FallbackController

  def index(conn, _params) do
    jobs = Api.list_jobs()
    render(conn, :index, jobs: jobs)
  end

  def create(conn, %{"job" => job_params}) do
    with {:ok, %Job{} = job} <- Api.create_job(job_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/jobs/#{job}")
      |> render(:show, job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Api.get_job!(id)
    render(conn, :show, job: job)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Api.get_job!(id)

    with {:ok, %Job{} = job} <- Api.update_job(job, job_params) do
      render(conn, :show, job: job)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Api.get_job!(id)

    with {:ok, %Job{}} <- Api.delete_job(job) do
      send_resp(conn, :no_content, "")
    end
  end

  def add(conn, %{"handler_id" => handler_id}) do
    resp =
      Api.create_job(%{
        handler_id: handler_id,
        status: "waiting",
        started_at: DateTime.utc_now()
      })

    render(conn, :add, resp: resp)
  end

  def restart(conn, %{"id" => id}) do
    resp = Bec.JobHandler.start(id)
    render(conn, :restart, resp: resp)
  end

  def cancel(conn, %{"id" => id}) do
    resp =
      case Registry.lookup(Bec.Registry.JobHandlers, job_handler: id) do
        [{pid, _}] ->
          GenServer.stop(pid, :normal)
          Bec.JobHandler.update_job(id, %{status: "cancelled"})
          {:ok, "Job cancelled"}

        [] ->
          {:error, "Job not found"}
      end

    render(conn, :cancel, resp: resp)
  end
end
