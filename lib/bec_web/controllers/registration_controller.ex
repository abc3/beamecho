defmodule BecWeb.RegistrationController do
  use BecWeb, :controller

  # alias Ecto.Changeset
  alias Plug.Conn
  alias Bec.Users.User
  alias Bec.Repo
  action_fallback BecWeb.FallbackController

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    if length(Repo.all(User)) > 0 do
      conn
      |> put_status(500)
      |> json(%{error: %{status: 500, message: "Admin user already exists"}})
    else
      conn
      |> Pow.Plug.create_user(user_params)
      |> case do
        {:ok, _user, conn} ->
          json(conn, %{
            data: %{
              access_token: conn.private.api_access_token,
              renewal_token: conn.private.api_renewal_token
            }
          })

        {:error, changeset, conn} ->
          # errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
          errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)

          conn
          |> put_status(500)
          |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
      end
    end
  end

  defp translate_error({msg, opts}) do
    # You can make use of gettext to translate error messages by
    # uncommenting and adjusting the following code:

    # if count = opts[:count] do
    #   Gettext.dngettext(BecWeb.Gettext, "errors", msg, msg, count, opts)
    # else
    #   Gettext.dgettext(BecWeb.Gettext, "errors", msg, opts)
    # end

    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
