defmodule Reverie.Repo.Migrations.CreateSticker do
  use Ecto.Migration

  def change do
    create table(:stickers) do
      add :title, :string
      add :sender_id, references(:users, on_delete: :nothing)
      add :receiver_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:stickers, [:sender_id])
    create index(:stickers, [:receiver_id])

  end
end
