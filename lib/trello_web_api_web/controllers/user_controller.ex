defmodule TrelloWebApiWeb.UserController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.Accounts
  alias TrelloWebApi.Accounts.User

  action_fallback TrelloWebApiWeb.FallbackController

  def index(conn, %{"search_query" => search_query}) do
    users = Accounts.list_users(search_query)
    render(conn, :index, users: users)
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.delete_user(user) do
      render(conn, :show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end
end
