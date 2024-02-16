defmodule TrelloWebApiWeb.CommentController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.Tasks
  alias TrelloWebApi.Tasks.Comment

  action_fallback TrelloWebApiWeb.FallbackController

  def index(conn, params) do
    comments = Tasks.list_comments(params)
    render(conn, :index, comments: comments)
  end

  def show(conn, %{"id" => comment_id}) do
    comment = Tasks.get_comment!(comment_id)
    render(conn, :show, comment: comment)
  end

  def create(conn, %{"id" => task_id, "creator_id" => creator_id, "comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Tasks.create_comment(task_id, creator_id, comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/comments/#{comment}")
      |> render(:show, comment: comment)
    end
  end

  def update(conn, %{"id" => comment_id, "comment" => comment_params}) do
    comment = Tasks.get_comment!(comment_id)

    with {:ok, %Comment{} = comment} <- Tasks.update_comment(comment, comment_params) do
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
