defmodule BecWeb.JobControllerTest do
  use BecWeb.ConnCase

  import Bec.ApiFixtures

  alias Bec.Api.Job

  @create_attrs %{
    status: "some status",
    started_at: ~N[2024-01-26 11:49:00],
    callback: "some callback",
    sent_success: 42,
    sent_failed: 42,
    finished_at: ~N[2024-01-26 11:49:00]
  }
  @update_attrs %{
    status: "some updated status",
    started_at: ~N[2024-01-27 11:49:00],
    callback: "some updated callback",
    sent_success: 43,
    sent_failed: 43,
    finished_at: ~N[2024-01-27 11:49:00]
  }
  @invalid_attrs %{status: nil, started_at: nil, callback: nil, sent_success: nil, sent_failed: nil, finished_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all jobs", %{conn: conn} do
      conn = get(conn, ~p"/api/jobs")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create job" do
    test "renders job when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/jobs", job: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/jobs/#{id}")

      assert %{
               "id" => ^id,
               "callback" => "some callback",
               "finished_at" => "2024-01-26T11:49:00",
               "sent_failed" => 42,
               "sent_success" => 42,
               "started_at" => "2024-01-26T11:49:00",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/jobs", job: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update job" do
    setup [:create_job]

    test "renders job when data is valid", %{conn: conn, job: %Job{id: id} = job} do
      conn = put(conn, ~p"/api/jobs/#{job}", job: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/jobs/#{id}")

      assert %{
               "id" => ^id,
               "callback" => "some updated callback",
               "finished_at" => "2024-01-27T11:49:00",
               "sent_failed" => 43,
               "sent_success" => 43,
               "started_at" => "2024-01-27T11:49:00",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, job: job} do
      conn = put(conn, ~p"/api/jobs/#{job}", job: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete job" do
    setup [:create_job]

    test "deletes chosen job", %{conn: conn, job: job} do
      conn = delete(conn, ~p"/api/jobs/#{job}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/jobs/#{job}")
      end
    end
  end

  defp create_job(_) do
    job = job_fixture()
    %{job: job}
  end
end
