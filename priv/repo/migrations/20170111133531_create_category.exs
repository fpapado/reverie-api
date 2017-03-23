defmodule Reverie.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :title, :string, null: false
      add :imgurl, :string, null: false

      timestamps()
    end

    create unique_index(:categories, [:title])
  end
end
