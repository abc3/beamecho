defmodule BecWeb.HandlerControllerTest do
  use BecWeb.ConnCase

  import Bec.ApiFixtures

  alias Bec.Api.Handler

  @create_attrs %{
    active: true,
    name: "some name",
    check_type: "some check_type",
    template: "some template",
    query: "some query",
    check_interval: 42
  }
  @update_attrs %{
    active: false,
    name: "some updated name",
    check_type: "some updated check_type",
    template: "some updated template",
    query: "some updated query",
    check_interval: 43
  }
  @invalid_attrs %{active: nil, name: nil, check_type: nil, template: nil, query: nil, check_interval: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all handlers", %{conn: conn} do
      conn = get(conn, ~p"/api/handlers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create handler" do
    test "renders handler when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/handlers", handler: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/handlers/#{id}")

      assert %{
               "id" => ^id,
               "active" => true,
               "check_interval" => 42,
               "check_type" => "some check_type",
               "name" => "some name",
               "query" => "some query",
               "template" => "some template"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/handlers", handler: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update handler" do
    setup [:create_handler]

    test "renders handler when data is valid", %{conn: conn, handler: %Handler{id: id} = handler} do
      conn = put(conn, ~p"/api/handlers/#{handler}", handler: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/handlers/#{id}")

      assert %{
               "id" => ^id,
               "active" => false,
               "check_interval" => 43,
               "check_type" => "some updated check_type",
               "name" => "some updated name",
               "query" => "some updated query",
               "template" => "some updated template"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, handler: handler} do
      conn = put(conn, ~p"/api/handlers/#{handler}", handler: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete handler" do
    setup [:create_handler]

    test "deletes chosen handler", %{conn: conn, handler: handler} do
      conn = delete(conn, ~p"/api/handlers/#{handler}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/handlers/#{handler}")
      end
    end
  end

  defp create_handler(_) do
    handler = handler_fixture()
    %{handler: handler}
  end
end
