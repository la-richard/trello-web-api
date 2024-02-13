defmodule TrelloWebApi.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :text
      add :creator_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :task_id, references(:tasks, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:creator_id])
    create index(:comments, [:task_id])
  end
end
