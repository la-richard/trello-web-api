defmodule TrelloWebApi.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :rank, :string
      add :board_id, references(:boards, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:lists, [:board_id])
    create unique_index(:lists, [:rank])
  end
end
