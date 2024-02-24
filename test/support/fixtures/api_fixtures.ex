defmodule Bec.ApiFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bec.Api` context.
  """

  @doc """
  Generate a source.
  """
  def source_fixture(attrs \\ %{}) do
    {:ok, source} =
      attrs
      |> Enum.into(%{
        dbname: "some dbname",
        dbpass: "some dbpass",
        dbport: 42,
        dbuser: "some dbuser",
        host: "some host",
        ip_version: 42,
        use_ssl: true
      })
      |> Bec.Api.create_source()

    source
  end

  @doc """
  Generate a app.
  """
  def app_fixture(attrs \\ %{}) do
    {:ok, app} =
      attrs
      |> Enum.into(%{
        app_bundle_id: "some app_bundle_id",
        key_file: "some key_file",
        key_id: "some key_id",
        team_id: "some team_id",
        type: "some type"
      })
      |> Bec.Api.create_app()

    app
  end

  @doc """
  Generate a handler.
  """
  def handler_fixture(attrs \\ %{}) do
    {:ok, handler} =
      attrs
      |> Enum.into(%{
        active: true,
        check_interval: 42,
        check_type: "some check_type",
        name: "some name",
        query: "some query",
        template: "some template"
      })
      |> Bec.Api.create_handler()

    handler
  end

  @doc """
  Generate a job.
  """
  def job_fixture(attrs \\ %{}) do
    {:ok, job} =
      attrs
      |> Enum.into(%{
        callback: "some callback",
        finished_at: ~N[2024-01-26 11:49:00],
        sent_failed: 42,
        sent_success: 42,
        started_at: ~N[2024-01-26 11:49:00],
        status: "some status"
      })
      |> Bec.Api.create_job()

    job
  end
end
