defmodule TrelloWebApi.Repo.Migrations.CreateBoardUsers do
  use Ecto.Migration

  def change do
    create table(:board_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :permission, :string
      add :board_id, references(:boards, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:board_users, [:board_id])
    create index(:board_users, [:user_id])
    create unique_index(:board_users, [:board_id, :user_id])
  end
end
