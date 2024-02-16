defmodule TrelloWebApiWeb.BoardJSON do
  alias TrelloWebApiWeb.ListJSON
  alias TrelloWebApiWeb.UserJSON
  alias TrelloWebApi.Boards.Board
  alias TrelloWebApiWeb.BoardUserJSON

  def index(%{boards: boards}) do
   %{data: for(board <- boards, do: data(board))}
  end

  def show(%{board: board}) do
    %{data: data(board)}
  end

  defp data(%Board{} = board, opts \\ []) do
    base_struct = %{
      id: board.id,
      name: board.name,
      visibility: board.visibility,
      users: BoardUserJSON.index(%{board_users: board.users}).data,
      owner: UserJSON.show(%{user: board.owner}).data
    }

    if Keyword.get(opts, :has_lists, false) do
      Map.put(base_struct, :lists, ListJSON.index(%{lists: board.lists}, has_tasks: true).data)
    else
      base_struct
    end
  end
end
