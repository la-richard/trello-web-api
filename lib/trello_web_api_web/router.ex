defmodule TrelloWebApiWeb.Router do
  use TrelloWebApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TrelloWebApi.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", TrelloWebApiWeb do
    pipe_through [:api, :auth]

    post "/login", AuthController, :login
    post "/users", UserController, :create
  end

  scope "/api", TrelloWebApiWeb do
    pipe_through [:api, :auth, :ensure_auth]

    get "/users", UserController, :index

    get "/users/:id", UserController, :show
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    get "/boards", BoardController, :index
    post "/boards", BoardController, :create

    get "/boards/:id", BoardController, :show
    put "/boards/:id", BoardController, :update
    delete "/boards/:id", BoardController, :delete
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:trello_web_api, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
