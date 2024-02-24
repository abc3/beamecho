defmodule BecWeb.Router do
  use BecWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BecWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug BecWeb.APIAuthPlug, otp_app: :beamecho
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: BecWeb.APIAuthErrorHandler
  end

  scope "/" do
    pipe_through :browser

    # pow_routes()
  end

  scope "/", BecWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", BecWeb do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
    get "currentUser", SessionController, :current_user, as: :current_user

    get("/handlers/:id/send", HandlerController, :send)
  end

  scope "/api", BecWeb do
    pipe_through [:api, :api_protected]

    resources "/sources", SourceController, except: [:new, :edit]
    resources "/apps", AppController
    resources "/handlers", HandlerController
    post "/handlers/source_query", HandlerController, :source_query
    resources "/jobs", JobController
    get "/jobs/:handler_id/add", JobController, :add
    get "/jobs/:id/restart", JobController, :restart
    get "/jobs/:id/cancel", JobController, :cancel
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:beamecho, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BecWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
