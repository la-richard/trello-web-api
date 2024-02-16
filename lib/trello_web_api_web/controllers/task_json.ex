defmodule TrelloWebApiWeb.TaskJSON do
  alias TrelloWebApiWeb.ListJSON
  alias TrelloWebApiWeb.CommentJSON
  alias TrelloWebApi.Tasks.Task

  def index(%{tasks: tasks}) do
    %{data: for(task <- tasks, do: data(task))}
  end

  def show(%{task: task}) do
    %{data: data(task, has_comments: true)}
  end

  defp data(%Task{} = task, opts \\ []) do
    base_struct = %{
      id: task.id,
      name: task.name,
      details: task.details,
      completed: task.completed,
      list_id: task.list_id,
      list: ListJSON.show(%{list: task.list}, has_tasks: false).data,
      reporter_id: task.reporter_id,
      assignee_id: task.assignee_id,
    }

    if Keyword.get(opts, :has_comments, false) do
      Map.put(base_struct, :comments, CommentJSON.index(%{comments: task.comments}).data)
    else
      base_struct
    end
  end
end
