defmodule BecWeb.SessionController do
  use BecWeb, :controller

  alias BecWeb.APIAuthPlug
  alias Plug.Conn

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        json(conn, %{
          data: %{
            access_token: conn.private.api_access_token,
            renewal_token: conn.private.api_renewal_token,
            email: conn.params["user"]["email"]
          }
        })

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  @spec renew(Conn.t(), map()) :: Conn.t()
  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> APIAuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, _user} ->
        json(conn, %{
          data: %{
            access_token: conn.private.api_access_token,
            renewal_token: conn.private.api_renewal_token
          }
        })
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> json(%{data: %{}})
  end

  def current_user(conn, _) do
    conn
    |> json(%{
      data: %{
        name: "test user",
        userid: "00000001",
        email: "test@example.com",
        title: "title",
        group: "group",
        tags: [
          %{key: "0", label: "label0"},
          %{key: "1", label: "label1"},
          %{key: "2", label: "label2"},
          %{key: "3", label: "label3"},
          %{key: "4", label: "label4"},
          %{key: "5", label: "label5"}
        ],
        notifyCount: 12,
        unreadCount: 11,
        country: "country",
        geographic: %{},
        address: "address",
        phone: "0000000000"
      }
    })
  end
end
