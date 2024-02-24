defmodule BecWeb.PageController do
  use BecWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "#{:code.priv_dir(:beamecho)}/static/dist/index.html")
  end
end
