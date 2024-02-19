defmodule TrelloWebApi.Boards do
  @moduledoc """
  The Boards context.
  """

  import Ecto.Query, warn: false
  alias TrelloWebApi.Accounts
  alias TrelloWebApi.Repo

  alias TrelloWebApi.Boards.Board
  alias TrelloWebApi.Boards.BoardUser

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards() do
    Repo.all(
      from(b in Board,
        where: b.visibility == :public,
        left_join: owner in assoc(b, :owner),
        left_join: users in assoc(b, :users),
        left_join: user in assoc(users, :user),
        order_by: [desc: :updated_at],
        preload: [owner: owner, users: {users, user: user}]
      )
    )
  end

  def list_boards(user_id) do
    Repo.all(
      from(b in Board,
        where: b.visibility == :public,
        or_where: b.owner_id == ^user_id,
        or_where: b.id in subquery(
          from(u in BoardUser,
            select: u.board_id,
            where: u.user_id ==^user_id
          )
        ),
        left_join: owner in assoc(b, :owner),
        left_join: users in assoc(b, :users),
        left_join: user in assoc(users, :user),
        order_by: [desc: :updated_at],
        preload: [owner: owner, users: {users, user: user}]
      )
    )
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id) do
    Repo.one!(
      from(b in Board,
        where: b.id == ^id,
        left_join: owner in assoc(b, :owner),
        left_join: users in assoc(b, :users),
        left_join: user in assoc(users, :user),
        preload: [owner: owner, users: {users, user: user}]
      )
    )
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(owner_id, attrs \\ %{}) do
    owner = Accounts.get_user!(owner_id)

    %Board{}
    |> Board.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:owner, owner)
    |> Repo.insert()
    |> case do
      {:ok, board} -> {:ok, get_board!(board.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  alias TrelloWebApi.Boards.BoardUser

  def add_user_to_board(board, %{"user_id" => user_id, "permission" => permission}) do
    user = Accounts.get_user!(user_id)

    %BoardUser{permission: String.to_atom(permission)}
    |> BoardUser.changeset(%{})
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:board, board)
    |> Repo.insert(on_conflict: [set: [permission: permission]], conflict_target: [:board_id, :user_id])
    |> case do
      {:ok, _} -> {:ok, get_board_user!(board.id, user_id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Returns the list of board_users.

  ## Examples

      iex> list_board_users()
      [%BoardUser{}, ...]

  """
  def list_board_users(board_id) do
    Repo.all(from(b in BoardUser, where: b.board_id == ^board_id, preload: [:user]))
  end

  @doc """
  Gets a single board_user.

  Raises `Ecto.NoResultsError` if the Board user does not exist.

  ## Examples

      iex> get_board_user!(123)
      %BoardUser{}

      iex> get_board_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_user!(board_id, user_id) do
    Repo.one!(
      from(u in BoardUser,
        where: [user_id: ^user_id, board_id: ^board_id],
        left_join: user in assoc(u, :user),
        preload: [user: user]
      )
    )
  end

  @doc """
  Creates a board_user.

  ## Examples

      iex> create_board_user(%{field: value})
      {:ok, %BoardUser{}}

      iex> create_board_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_user(attrs \\ %{}) do
    %BoardUser{}
    |> BoardUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board_user.

  ## Examples

      iex> update_board_user(board_user, %{field: new_value})
      {:ok, %BoardUser{}}

      iex> update_board_user(board_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_user(%BoardUser{} = board_user, attrs) do
    board_user
    |> BoardUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board_user.

  ## Examples

      iex> delete_board_user(board_user)
      {:ok, %BoardUser{}}

      iex> delete_board_user(board_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_user(%BoardUser{} = board_user) do
    Repo.delete(board_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_user changes.

  ## Examples

      iex> change_board_user(board_user)
      %Ecto.Changeset{data: %BoardUser{}}

  """
  def change_board_user(%BoardUser{} = board_user, attrs \\ %{}) do
    BoardUser.changeset(board_user, attrs)
  end
end
