defmodule Reverie.Repo.Migrations.AddPermissionsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean, default: false, null: false
    end
  end
end
