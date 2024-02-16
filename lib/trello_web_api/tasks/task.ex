defmodule TrelloWebApi.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field :name, :string
    field :details, :string
    field :rank, :string
    field :completed, :boolean, default: false

    belongs_to :reporter, TrelloWebApi.Accounts.User, on_replace: :nilify
    belongs_to :assignee, TrelloWebApi.Accounts.User, on_replace: :nilify
    belongs_to :list, TrelloWebApi.Lists.List, on_replace: :nilify

    has_many :comments, TrelloWebApi.Tasks.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :details, :rank, :completed])
    |> validate_required([:name, :rank, :completed])
    |> unique_constraint(:rank)
  end
end
