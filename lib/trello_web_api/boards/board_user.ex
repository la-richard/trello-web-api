defmodule TrelloWebApi.Boards.BoardUser do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "board_users" do
    field :permission, Ecto.Enum, values: [:manage, :write, :read], default: :read

    belongs_to :board, TrelloWebApi.Boards.Board
    belongs_to :user, TrelloWebApi.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(board_user, attrs) do
    board_user
    |> cast(attrs, [:permission])
    |> validate_required([:permission])
  end
end
