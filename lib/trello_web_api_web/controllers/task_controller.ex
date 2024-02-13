defmodule TrelloWebApiWeb.TaskController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.Tasks

  def index(conn, params) do
    tasks = Tasks.list_tasks(params)
    render(conn, :index, tasks: tasks)
  end

  def show(conn, %{"id" => task_id}) do
    task = Tasks.get_task!(task_id)
    render(conn, :show, task: task)
  end

  def create(conn, %{"id" => list_id, "reporter_id" => reporter_id, "task" => task_params}) do
    with {:ok, task} <- Tasks.create_task(list_id, reporter_id, task_params) do
      render(conn, :show, task: task)
    end
  end

  def update(conn, %{"id" => task_id, "task" => task_params}) do
    task = Tasks.update_task(task_id, task_params)

    with {:ok, task} <- Tasks.update_task(task, task_params) do
      render(conn, :show, task: task)
    end
  end

  def delete(conn, %{"id" => task_id}) do
    task = Tasks.get_task!(task_id)

    with {:ok, task} <- Tasks.delete_task(task) do
      render(conn, :show, task: task)
    end
  end

  def reorder(conn, %{"id" => task_id} = params) do
    prev_id = Map.get(params, "prev_id")
    next_id = Map.get(params, "next_id")
    with {:ok, task} <- Tasks.reorder_task(task_id, prev_id, next_id) do
      render(conn, :show, task: task)
    end
  end

  def assign(conn, %{"id" => task_id, "assignee_id" => assignee_id}) do
    with {:ok, task} <- Tasks.assign_task_to_user(task_id, assignee_id) do
      render(conn, :show, task: task)
    end
  end
end
