defmodule TrelloWebApiWeb.UserJSON do
  alias TrelloWebApi.Accounts.User

  def index(%{users: users}) do
   %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  def login(%{user: user, token: token}) do
    %{data: %{user: data(user), token: token}}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
    }
  end
end
