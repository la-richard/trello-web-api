defmodule TrelloWebApiWeb.BoardJSON do
  alias TrelloWebApi.Boards.Board

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
      visibility: board.visibility
    }
  end
end
