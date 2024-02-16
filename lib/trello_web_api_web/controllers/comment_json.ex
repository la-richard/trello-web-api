defmodule TrelloWebApiWeb.CommentJSON do
  alias TrelloWebApi.Tasks.Comment

  def index(%{comments: %Ecto.Association.NotLoaded{}} = _params) do
    %{data: []}
  end

  def index(%{comments: comments}) do
    %{data: for(comment <- comments, do: data(comment))}
  end

  def show(%{comment: comment}) do
    %{data: data(comment)}
  end

  defp data(%Comment{} = comment) do
    %{
      body: comment.body,
      creator_id: comment.creator_id,
      creator_email: comment.creator.email,
      updated_at: comment.updated_at,
      created_at: comment.inserted_at
    }
  end

  defp data(%Ecto.Association.NotLoaded{} = comment) do
    comment
  end
end
