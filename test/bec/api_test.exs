defmodule Bec.ApiTest do
  use Bec.DataCase

  alias Bec.Api

  describe "sources" do
    alias Bec.Api.Source

    import Bec.ApiFixtures

    @invalid_attrs %{host: nil, dbname: nil, dbuser: nil, dbpass: nil, dbport: nil, use_ssl: nil, ip_version: nil}

    test "list_sources/0 returns all sources" do
      source = source_fixture()
      assert Api.list_sources() == [source]
    end

    test "get_source!/1 returns the source with given id" do
      source = source_fixture()
      assert Api.get_source!(source.id) == source
    end

    test "create_source/1 with valid data creates a source" do
      valid_attrs = %{host: "some host", dbname: "some dbname", dbuser: "some dbuser", dbpass: "some dbpass", dbport: 42, use_ssl: true, ip_version: 42}

      assert {:ok, %Source{} = source} = Api.create_source(valid_attrs)
      assert source.host == "some host"
      assert source.dbname == "some dbname"
      assert source.dbuser == "some dbuser"
      assert source.dbpass == "some dbpass"
      assert source.dbport == 42
      assert source.use_ssl == true
      assert source.ip_version == 42
    end

    test "create_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_source(@invalid_attrs)
    end

    test "update_source/2 with valid data updates the source" do
      source = source_fixture()
      update_attrs = %{host: "some updated host", dbname: "some updated dbname", dbuser: "some updated dbuser", dbpass: "some updated dbpass", dbport: 43, use_ssl: false, ip_version: 43}

      assert {:ok, %Source{} = source} = Api.update_source(source, update_attrs)
      assert source.host == "some updated host"
      assert source.dbname == "some updated dbname"
      assert source.dbuser == "some updated dbuser"
      assert source.dbpass == "some updated dbpass"
      assert source.dbport == 43
      assert source.use_ssl == false
      assert source.ip_version == 43
    end

    test "update_source/2 with invalid data returns error changeset" do
      source = source_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_source(source, @invalid_attrs)
      assert source == Api.get_source!(source.id)
    end

    test "delete_source/1 deletes the source" do
      source = source_fixture()
      assert {:ok, %Source{}} = Api.delete_source(source)
      assert_raise Ecto.NoResultsError, fn -> Api.get_source!(source.id) end
    end

    test "change_source/1 returns a source changeset" do
      source = source_fixture()
      assert %Ecto.Changeset{} = Api.change_source(source)
    end
  end

  describe "app" do
    alias Bec.Api.App

    import Bec.ApiFixtures

    @invalid_attrs %{type: nil, team_id: nil, key_id: nil, key_file: nil, app_bundle_id: nil}

    test "list_app/0 returns all app" do
      app = app_fixture()
      assert Api.list_app() == [app]
    end

    test "get_app!/1 returns the app with given id" do
      app = app_fixture()
      assert Api.get_app!(app.id) == app
    end

    test "create_app/1 with valid data creates a app" do
      valid_attrs = %{type: "some type", team_id: "some team_id", key_id: "some key_id", key_file: "some key_file", app_bundle_id: "some app_bundle_id"}

      assert {:ok, %App{} = app} = Api.create_app(valid_attrs)
      assert app.type == "some type"
      assert app.team_id == "some team_id"
      assert app.key_id == "some key_id"
      assert app.key_file == "some key_file"
      assert app.app_bundle_id == "some app_bundle_id"
    end

    test "create_app/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_app(@invalid_attrs)
    end

    test "update_app/2 with valid data updates the app" do
      app = app_fixture()
      update_attrs = %{type: "some updated type", team_id: "some updated team_id", key_id: "some updated key_id", key_file: "some updated key_file", app_bundle_id: "some updated app_bundle_id"}

      assert {:ok, %App{} = app} = Api.update_app(app, update_attrs)
      assert app.type == "some updated type"
      assert app.team_id == "some updated team_id"
      assert app.key_id == "some updated key_id"
      assert app.key_file == "some updated key_file"
      assert app.app_bundle_id == "some updated app_bundle_id"
    end

    test "update_app/2 with invalid data returns error changeset" do
      app = app_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_app(app, @invalid_attrs)
      assert app == Api.get_app!(app.id)
    end

    test "delete_app/1 deletes the app" do
      app = app_fixture()
      assert {:ok, %App{}} = Api.delete_app(app)
      assert_raise Ecto.NoResultsError, fn -> Api.get_app!(app.id) end
    end

    test "change_app/1 returns a app changeset" do
      app = app_fixture()
      assert %Ecto.Changeset{} = Api.change_app(app)
    end
  end

  describe "handlers" do
    alias Bec.Api.Handler

    import Bec.ApiFixtures

    @invalid_attrs %{active: nil, name: nil, check_type: nil, template: nil, query: nil, check_interval: nil}

    test "list_handlers/0 returns all handlers" do
      handler = handler_fixture()
      assert Api.list_handlers() == [handler]
    end

    test "get_handler!/1 returns the handler with given id" do
      handler = handler_fixture()
      assert Api.get_handler!(handler.id) == handler
    end

    test "create_handler/1 with valid data creates a handler" do
      valid_attrs = %{active: true, name: "some name", check_type: "some check_type", template: "some template", query: "some query", check_interval: 42}

      assert {:ok, %Handler{} = handler} = Api.create_handler(valid_attrs)
      assert handler.active == true
      assert handler.name == "some name"
      assert handler.check_type == "some check_type"
      assert handler.template == "some template"
      assert handler.query == "some query"
      assert handler.check_interval == 42
    end

    test "create_handler/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_handler(@invalid_attrs)
    end

    test "update_handler/2 with valid data updates the handler" do
      handler = handler_fixture()
      update_attrs = %{active: false, name: "some updated name", check_type: "some updated check_type", template: "some updated template", query: "some updated query", check_interval: 43}

      assert {:ok, %Handler{} = handler} = Api.update_handler(handler, update_attrs)
      assert handler.active == false
      assert handler.name == "some updated name"
      assert handler.check_type == "some updated check_type"
      assert handler.template == "some updated template"
      assert handler.query == "some updated query"
      assert handler.check_interval == 43
    end

    test "update_handler/2 with invalid data returns error changeset" do
      handler = handler_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_handler(handler, @invalid_attrs)
      assert handler == Api.get_handler!(handler.id)
    end

    test "delete_handler/1 deletes the handler" do
      handler = handler_fixture()
      assert {:ok, %Handler{}} = Api.delete_handler(handler)
      assert_raise Ecto.NoResultsError, fn -> Api.get_handler!(handler.id) end
    end

    test "change_handler/1 returns a handler changeset" do
      handler = handler_fixture()
      assert %Ecto.Changeset{} = Api.change_handler(handler)
    end
  end

  describe "jobs" do
    alias Bec.Api.Job

    import Bec.ApiFixtures

    @invalid_attrs %{status: nil, started_at: nil, callback: nil, sent_success: nil, sent_failed: nil, finished_at: nil}

    test "list_jobs/0 returns all jobs" do
      job = job_fixture()
      assert Api.list_jobs() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Api.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      valid_attrs = %{status: "some status", started_at: ~N[2024-01-26 11:49:00], callback: "some callback", sent_success: 42, sent_failed: 42, finished_at: ~N[2024-01-26 11:49:00]}

      assert {:ok, %Job{} = job} = Api.create_job(valid_attrs)
      assert job.status == "some status"
      assert job.started_at == ~N[2024-01-26 11:49:00]
      assert job.callback == "some callback"
      assert job.sent_success == 42
      assert job.sent_failed == 42
      assert job.finished_at == ~N[2024-01-26 11:49:00]
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      update_attrs = %{status: "some updated status", started_at: ~N[2024-01-27 11:49:00], callback: "some updated callback", sent_success: 43, sent_failed: 43, finished_at: ~N[2024-01-27 11:49:00]}

      assert {:ok, %Job{} = job} = Api.update_job(job, update_attrs)
      assert job.status == "some updated status"
      assert job.started_at == ~N[2024-01-27 11:49:00]
      assert job.callback == "some updated callback"
      assert job.sent_success == 43
      assert job.sent_failed == 43
      assert job.finished_at == ~N[2024-01-27 11:49:00]
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_job(job, @invalid_attrs)
      assert job == Api.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Api.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Api.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Api.change_job(job)
    end
  end
end
