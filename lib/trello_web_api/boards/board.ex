defmodule TrelloWebApi.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "boards" do
    field :name, :string
    field :visibility, Ecto.Enum, values: [:private, :public], default: :public

    belongs_to :owner, TrelloWebApi.Accounts.User

    has_many :users, TrelloWebApi.Boards.BoardUser
    has_many :lists, TrelloWebApi.Lists.List

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :visibility])
    |> validate_required([:name, :visibility])
  end
end
