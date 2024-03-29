defmodule TrelloWebApi.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias TrelloWebApi.Boards
  alias TrelloWebApi.Repo

  alias TrelloWebApi.Lists.List

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """

  def list_lists(%{"board_id" => board_id}) do
    Repo.all(
      from(l in List,
        where: l.board_id == ^board_id,
        order_by: [asc: l.rank]
      )
    )
  end

  def list_lists(%{}) do
    Repo.all(List)
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id) do
    Repo.one!(
      from(l in List,
        where: l.id == ^id,
        left_join: tasks in assoc(l, :tasks),
        left_join: reporter in assoc(tasks, :reporter),
        left_join: assignee in assoc(tasks, :assignee),
        preload: [tasks: {tasks, [reporter: reporter, assignee: assignee]}]
      )
    )
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(board_id, attrs \\ %{}) do
    board = Boards.get_board!(board_id)

    %List{}
    |> List.changeset(Map.merge(attrs, %{"rank" => Ranker.new(List)}))
    |> Ecto.Changeset.put_assoc(:board, board)
    |> Repo.insert()
    |> case do
      {:ok, list} -> {:ok, get_list!(list.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  def reorder_list(list_id, prev_id, next_id) do
    IO.inspect(list_id)
    list = get_list!(list_id)

    rank = Ranker.reorder(List, prev_id, next_id)

    list
    |> List.changeset(%{rank: rank})
    |> Repo.update()
    |> case do
      {:ok, list} -> {:ok, get_list!(list.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
