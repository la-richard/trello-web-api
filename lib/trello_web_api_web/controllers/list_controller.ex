defmodule TrelloWebApiWeb.ListController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.Lists

  action_fallback TrelloWebApiWeb.FallbackController

  def index(conn, params) do
    lists = Lists.list_lists(params)
    render(conn, :index, lists: lists)
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    render(conn, :show, list: list)
  end

  def create(conn, %{"board_id" => board_id, "list" => list_params}) do
    with {:ok, list} <- Lists.create_list(board_id, list_params) do
      render(conn, :show, list: list)
    end
  end

  def update(conn, %{"id" => list_id, "list" => list_params}) do
    list = Lists.get_list!(list_id)

    with {:ok, list} <- Lists.update_list(list, list_params) do
      render(conn, :show, list: list)
    end
  end

  def reorder(conn, %{"id" => list_id} = params) do
    prev_id = Map.get(params, "prev_id")
    next_id = Map.get(params, "next_id")
    with {:ok, list} <- Lists.reorder_list(list_id, prev_id, next_id) do
      render(conn, :show, list: list)
    end
  end

  def delete(conn, %{"id" => list_id}) do
    list = Lists.get_list!(list_id)

    with {:ok, list} <- Lists.delete_list(list) do
      render(conn, :show, list: list)
    end
  end
end
