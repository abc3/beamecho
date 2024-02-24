defmodule BecWeb.AppControllerTest do
  use BecWeb.ConnCase

  import Bec.ApiFixtures

  alias Bec.Api.App

  @create_attrs %{
    type: "some type",
    team_id: "some team_id",
    key_id: "some key_id",
    key_file: "some key_file",
    app_bundle_id: "some app_bundle_id"
  }
  @update_attrs %{
    type: "some updated type",
    team_id: "some updated team_id",
    key_id: "some updated key_id",
    key_file: "some updated key_file",
    app_bundle_id: "some updated app_bundle_id"
  }
  @invalid_attrs %{type: nil, team_id: nil, key_id: nil, key_file: nil, app_bundle_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all app", %{conn: conn} do
      conn = get(conn, ~p"/api/app")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create app" do
    test "renders app when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/app", app: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/app/#{id}")

      assert %{
               "id" => ^id,
               "app_bundle_id" => "some app_bundle_id",
               "key_file" => "some key_file",
               "key_id" => "some key_id",
               "team_id" => "some team_id",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/app", app: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update app" do
    setup [:create_app]

    test "renders app when data is valid", %{conn: conn, app: %App{id: id} = app} do
      conn = put(conn, ~p"/api/app/#{app}", app: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/app/#{id}")

      assert %{
               "id" => ^id,
               "app_bundle_id" => "some updated app_bundle_id",
               "key_file" => "some updated key_file",
               "key_id" => "some updated key_id",
               "team_id" => "some updated team_id",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, app: app} do
      conn = put(conn, ~p"/api/app/#{app}", app: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete app" do
    setup [:create_app]

    test "deletes chosen app", %{conn: conn, app: app} do
      conn = delete(conn, ~p"/api/app/#{app}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/app/#{app}")
      end
    end
  end

  defp create_app(_) do
    app = app_fixture()
    %{app: app}
  end
end
