defmodule TrelloWebApiWeb.BoardJSON do
  alias TrelloWebApiWeb.UserJSON
  alias TrelloWebApi.Boards.Board
  alias TrelloWebApiWeb.BoardUserJSON

  def index(%{boards: boards}) do
   %{data: for(board <- boards, do: data(board))}
  end

  def show(%{board: board}) do
    %{data: data(board)}
  end

  defp data(%Board{} = board) do
    %{
      id: board.id,
      name: board.name,
      visibility: board.visibility,
      users: BoardUserJSON.index(%{board_users: board.users}).data,
      owner: UserJSON.show(%{user: board.owner}).data
    }
  end
end
