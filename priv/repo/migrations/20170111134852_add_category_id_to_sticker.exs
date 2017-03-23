defmodule Reverie.Repo.Migrations.AddCategoryIdToSticker do
  use Ecto.Migration

  def change do
    alter table(:stickers) do
      add :category_id, references(:categories)
    end
  end
end
