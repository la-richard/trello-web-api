defmodule TrelloWebApiWeb.CommentController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.Tasks

  def index(conn, params) do
    comments = Tasks.list_comments(params)
    render(conn, :index, comments: comments)
  end

  def show(conn, %{"id" => comment_id}) do
    comment = Tasks.get_comment!(comment_id)
    render(conn, :show, comment: comment)
  end

  def create(conn, %{"id" => task_id, "creator_id" => creator_id, "comment" => comment_params}) do
    with {:ok, comment} <- Tasks.create_comment(task_id, creator_id, comment_params) do
      render(conn, :show, comment: comment)
    end
  end

  def update(conn, %{"id" => comment_id, "comment" => comment_params}) do
    comment = Tasks.get_comment!(comment_id)

    with {:ok, comment} <- Tasks.update_comment(comment, comment_params) do
      render(conn, :show, comment: comment)
    end
  end

  def delete(conn, %{"id" => comment_id}) do
    comment = Tasks.get_comment!(comment_id)

    with {:ok, comment} <- Tasks.delete_comment(comment) do
      render(conn, :show, comment: comment)
    end
  end
end
