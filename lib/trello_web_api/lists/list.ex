defmodule TrelloWebApi.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lists" do
    field :name, :string
    field :rank, :string

    belongs_to :board, TrelloWebApi.Boards.Board

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name, :rank])
    |> validate_required([:name, :rank])
    |> unique_constraint(:rank)
  end
end
