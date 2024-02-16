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
  def list_tasks(%{"list_id" => list_id}) do
    Repo.all(
      from(t in Task,
        where: t.list_id == ^list_id,
        order_by: [asc: t.rank],
        left_join: reporter in assoc(t, :reporter),
        left_join: assignee in assoc(t, :assignee),
        left_join: list in assoc(t, :list),
        preload: [reporter: reporter, assignee: assignee, list: list]
        )
      )
  end

  def list_tasks(%{}) do
    Repo.all(Task)
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
    Repo.one!(
      from(t in Task,
        where: t.id == ^id,
        left_join: reporter in assoc(t, :reporter),
        left_join: assignee in assoc(t, :assignee),
        left_join: list in assoc(t, :list),
        left_join: comments in assoc(t, :comments),
        left_join: creator in assoc(comments, :creator),
        preload: [reporter: reporter, assignee: assignee, list: list, comments: {comments, creator: creator}]
      )
    )
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

  def move_to_list_and_reorder(list_id, task_id, nil, nil) do
    IO.inspect(list_id)
    IO.inspect(task_id)
    list = Lists.get_list!(list_id)
    task = get_task!(task_id)

    rank = Ranker.new(Task)

    task
    |> Task.changeset(%{rank: rank})
    |> Ecto.Changeset.put_assoc(:list, list)
    |> Repo.update()
    |> case do
      {:ok, task} -> {:ok, get_task!(task.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def move_to_list_and_reorder(list_id, task_id, prev_id, next_id) do
    list = Lists.get_list!(list_id)
    task = get_task!(task_id)

    rank = Ranker.reorder(Task, prev_id, next_id)

    task
    |> Task.changeset(%{rank: rank})
    |> Ecto.Changeset.put_assoc(:list, list)
    |> Repo.update()
    |> case do
      {:ok, task} -> {:ok, get_task!(task.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def assign_task_to_user(task_id, assignee_id) do
    task = get_task!(task_id)
    assignee = Accounts.get_user!(assignee_id)

    task
    |> Task.changeset(%{})
    |> Ecto.Changeset.put_assoc(:assignee, assignee)
    |> Repo.update()
    |> case do
      {:ok, task} -> {:ok, get_task!(task.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  alias TrelloWebApi.Tasks.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments(%{"id" => task_id}) do
    Repo.all(
      from(c in Comment,
        where: c.task_id == ^task_id,
        left_join: creator in assoc(c, :creator),
        order_by: [asc: :updated_at],
        preload: [creator: creator]
      )
    )
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.one!(
    from(c in Comment,
      where: c.id == ^id,
      left_join: creator in assoc(c, :creator),
      preload: [creator: creator]
    )
  )

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(task_id, creator_id, attrs \\ %{}) do
    task = get_task!(task_id)
    creator = Accounts.get_user!(creator_id)

    %Comment{}
    |> Comment.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:task, task)
    |> Ecto.Changeset.put_assoc(:creator, creator)
    |> Repo.insert()
    |> case do
      {:ok, comment} -> {:ok, get_comment!(comment.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, comment} -> {:ok, get_comment!(comment.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
