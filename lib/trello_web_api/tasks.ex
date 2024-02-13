defmodule TrelloWebApi.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TrelloWebApi.Accounts
  alias TrelloWebApi.Lists
  alias TrelloWebApi.Repo

  alias TrelloWebApi.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks(list_id) do
    Repo.all(from(t in Task, where: t.list_id == ^list_id, order_by: [asc: t.rank]))
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Task
    |> Repo.get!(id)
    |> Repo.preload([:reporter, :assignee, :list])
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(list_id, reporter_id, attrs \\ %{}) do
    list = Lists.get_list!(list_id)
    reporter = Accounts.get_user!(reporter_id)

    %Task{}
    |> Task.changeset(Map.merge(attrs, %{"rank" => Ranker.new(Task)}))
    |> Ecto.Changeset.put_assoc(:list, list)
    |> Ecto.Changeset.put_assoc(:reporter, reporter)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def reorder_task(task_id, prev_id, next_id) do
    task = get_task!(task_id)

    rank = Ranker.reorder(Task, prev_id, next_id)

    task
    |> Task.changeset(%{rank: rank})
    |> Repo.update()
    |> case do
      {:ok, task} -> {:ok, get_task!(task.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
