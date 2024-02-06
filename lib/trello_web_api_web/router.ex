defmodule TrelloWebApiWeb.Router do
  use TrelloWebApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TrelloWebApiWeb do
    pipe_through :api

    get "/users", UserController, :index
    post "/users", UserController, :create

    get "/users/:id", UserController, :show
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:trello_web_api, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
