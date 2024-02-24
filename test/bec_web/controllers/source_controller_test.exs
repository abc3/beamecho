defmodule BecWeb.SourceControllerTest do
  use BecWeb.ConnCase

  import Bec.ApiFixtures

  alias Bec.Api.Source

  @create_attrs %{
    host: "some host",
    dbname: "some dbname",
    dbuser: "some dbuser",
    dbpass: "some dbpass",
    dbport: 42,
    use_ssl: true,
    ip_version: 42
  }
  @update_attrs %{
    host: "some updated host",
    dbname: "some updated dbname",
    dbuser: "some updated dbuser",
    dbpass: "some updated dbpass",
    dbport: 43,
    use_ssl: false,
    ip_version: 43
  }
  @invalid_attrs %{host: nil, dbname: nil, dbuser: nil, dbpass: nil, dbport: nil, use_ssl: nil, ip_version: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sources", %{conn: conn} do
      conn = get(conn, ~p"/api/sources")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create source" do
    test "renders source when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/sources", source: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/sources/#{id}")

      assert %{
               "id" => ^id,
               "dbname" => "some dbname",
               "dbpass" => "some dbpass",
               "dbport" => 42,
               "dbuser" => "some dbuser",
               "host" => "some host",
               "ip_version" => 42,
               "use_ssl" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/sources", source: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update source" do
    setup [:create_source]

    test "renders source when data is valid", %{conn: conn, source: %Source{id: id} = source} do
      conn = put(conn, ~p"/api/sources/#{source}", source: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/sources/#{id}")

      assert %{
               "id" => ^id,
               "dbname" => "some updated dbname",
               "dbpass" => "some updated dbpass",
               "dbport" => 43,
               "dbuser" => "some updated dbuser",
               "host" => "some updated host",
               "ip_version" => 43,
               "use_ssl" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, source: source} do
      conn = put(conn, ~p"/api/sources/#{source}", source: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete source" do
    setup [:create_source]

    test "deletes chosen source", %{conn: conn, source: source} do
      conn = delete(conn, ~p"/api/sources/#{source}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/sources/#{source}")
      end
    end
  end

  defp create_source(_) do
    source = source_fixture()
    %{source: source}
  end
end
