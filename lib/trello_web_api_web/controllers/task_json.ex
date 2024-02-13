defmodule TrelloWebApiWeb.TaskJSON do
  alias TrelloWebApi.Tasks.Task

  def index(%{tasks: tasks}) do
    %{data: for(task <- tasks, do: data(task))}
  end

  def show(%{task: task}) do
    %{data: data(task)}
  end

  defp data(%Task{} = task) do
    %{
      id: task.id,
      name: task.name,
      details: task.details,
      completed: task.completed,
      list_id: task.list_id,
      reporter_id: task.reporter_id,
      assignee_id: task.assignee_id
    }
  end
end
