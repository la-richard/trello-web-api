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

  def create(conn, %{"list_id" => list_id, "reporter_id" => reporter_id, "task" => task_params}) do
    with {:ok, task} <- Tasks.create_task(list_id, reporter_id, task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, task: task)
    end
  end

  def update(conn, %{"id" => task_id, "task" => task_params}) do
    task = Tasks.get_task!(task_id)

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
    list_id = Map.get(params, "list_id")
    prev_id = Map.get(params, "prev_id")
    next_id = Map.get(params, "next_id")
    if list_id do
      IO.inspect(next_id)
      IO.inspect(prev_id)
      with {:ok, task} <- Tasks.move_to_list_and_reorder(list_id, task_id, prev_id, next_id) do
        render(conn, :show, task: task)
      end
    else
      with {:ok, task} <- Tasks.reorder_task(task_id, prev_id, next_id) do
        render(conn, :show, task: task)
      end
    end
  end

  def assign(conn, %{"id" => task_id, "assignee_id" => assignee_id}) do
    with {:ok, task} <- Tasks.assign_task_to_user(task_id, assignee_id) do
      render(conn, :show, task: task)
    end
  end
end
