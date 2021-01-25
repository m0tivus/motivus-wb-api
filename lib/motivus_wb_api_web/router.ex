defmodule MotivusWbApiWeb.Router do
  use MotivusWbApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MotivusWbApi.Users.Pipeline
  end

  scope "/", MotivusWbApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/metrics/tasks", PageController, :tasks_queue_total
  end

  scope "/auth", MotivusWbApiWeb do
    pipe_through([:api])

    post "/guest", AuthController, :create_guest

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    # post("/logout", AuthController, :delete)
  end

  scope "/api", MotivusWbApiWeb do
    pipe_through([:api])

    # get "/user/processing_preferences", PageController, :processing_preferences
    post "/users/guest", PageController, :create_guest

    pipe_through([:auth])

    get "/user", Users.UserController, :get
    resources "/users", Users.UserController, as: :users_user
    resources "/tasks", Processing.TaskController, as: :processing_task
  end

  # Other scopes may use custom stacks.
  # scope "/api", MotivusWbApiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MotivusWbApiWeb.Telemetry
    end
  end
end
