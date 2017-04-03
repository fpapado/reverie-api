defmodule Reverie.Repo.Migrations.AddCategoryPermissions do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :admin_only, :boolean, default: false, null: false
    end
  end
end
