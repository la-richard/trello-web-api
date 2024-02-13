defmodule TrelloWebApiWeb.BoardUserController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.Boards.BoardUser
  alias TrelloWebApi.Boards

  action_fallback TrelloWebApiWeb.FallbackController

  def index(conn, %{"id" => board_id}) do
    board_users = Boards.list_board_users(board_id)
    render(conn, :index, board_users: board_users)
  end

  def create_or_update(conn, %{"id" => board_id, "board_user" => board_user_params}) do
    board = Boards.get_board!(board_id)
    with {:ok, %BoardUser{} = board_user} <- Boards.add_user_to_board(board, board_user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/boards/#{board}/users/#{board_user}")
      |> render(:show, board_user: board_user)
    end
  end

  def show(conn, %{"id" => board_id, "user_id" => user_id}) do
    board_user = Boards.get_board_user!(board_id, user_id)
    render(conn, :show, board_user: board_user)
  end

  def delete(conn, %{"id" => board_id, "user_id" => user_id}) do
    board_user = Boards.get_board_user!(board_id, user_id)

    with {:ok, %BoardUser{} = board_user} <- Boards.delete_board_user(board_user) do
      render(conn, :show, board_user: board_user)
    end
  end

end
