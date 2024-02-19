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
    get "/users/verify", AuthController, :verify_user

    get "/users/:id", UserController, :show
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    get "/boards", BoardController, :index
    post "/boards", BoardController, :create

    get "/boards/:id", BoardController, :show
    put "/boards/:id", BoardController, :update
    delete "/boards/:id", BoardController, :delete

    get "/boards/:id/users", BoardUserController, :index
    put "/boards/:id/users", BoardUserController, :create_or_update
    get "/boards/:id/users/:user_id", BoardUserController, :show
    delete "/boards/:id/users/:user_id", BoardUserController, :delete

    get "/boards/:board_id/lists", ListController, :index
    post "/boards/:board_id/lists", ListController, :create

    get "/lists", ListController, :index
    get "/lists/:id", ListController, :show
    put "/lists/:id", ListController, :update
    delete "/lists/:id", ListController, :delete
    put "/lists/:id/reorder", ListController, :reorder

    get "/lists/:list_id/tasks", TaskController, :index
    post "/lists/:list_id/tasks", TaskController, :create

    get "/tasks", TaskController, :index
    get "/tasks/:id", TaskController, :show
    put "/tasks/:id", TaskController, :update
    delete "/tasks/:id/", TaskController, :delete
    put "/tasks/:id/reorder", TaskController, :reorder
    get "/tasks/:id/comments", CommentController, :index
    post "/tasks/:id/comments", CommentController, :create

    get "/comments", CommentController, :index
    get "/comments/:id", CommentController, :show
    put "/comments/:id", CommentController, :update
    delete "/comments/:id", CommentController, :delete
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:trello_web_api, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
