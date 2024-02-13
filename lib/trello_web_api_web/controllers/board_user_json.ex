defmodule TrelloWebApiWeb.BoardUserJSON do
  alias TrelloWebApi.Boards.BoardUser

  def index(%{board_users: board_users}) do
    %{data: for(board_user <- board_users, do: data(board_user))}
  end

  def show(%{board_user: board_user}) do
    %{data: data(board_user)}
  end

  defp data(%BoardUser{} = board_user) do
    %{
      user_id: board_user.user.id,
      email: board_user.user.email,
      permission: board_user.permission
    }
  end
end
