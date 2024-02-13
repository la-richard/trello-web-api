defmodule TrelloWebApiWeb.BoardController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.Boards
  alias TrelloWebApi.Boards.Board

  action_fallback TrelloWebApiWeb.FallbackController

  def index(%{query_params: %{ "user_id" => user_id}} = conn, _params) do
    boards = Boards.list_boards(user_id)
    render(conn, :index, boards: boards)
  end

  def index(conn, _params) do
    boards = Boards.list_boards()
    render(conn, :index, boards: boards)
  end

  def create(conn, %{"board" => board_params, "user_id" => user_id}) do
    with {:ok, %Board{} = board} <- Boards.create_board(user_id, board_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/boards/#{board}")
      |> render(:show, board: board)
    end
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{} = board} <- Boards.update_board(board, board_params) do
      render(conn, :show, board: board)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{} = board} <- Boards.delete_board(board) do
      render(conn, :show, board: board)
    end
  end

  def show(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    render(conn, :show, board: board)
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end

end
