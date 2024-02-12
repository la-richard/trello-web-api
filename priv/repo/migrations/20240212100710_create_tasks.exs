defmodule TrelloWebApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :details, :string
      add :rank, :string
      add :completed, :boolean, default: false, null: false
      add :reporter_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :assignee_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :list_id, references(:lists, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tasks, [:rank])
    create index(:tasks, [:reporter_id])
    create index(:tasks, [:assignee_id])
    create index(:tasks, [:list_id])
  end
end
