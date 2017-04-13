defmodule Reverie.Repo.Migrations.AddUsernameToUsers do
  use Ecto.Migration
  import Ecto.Query

  def change do
    # Add initial username column
    alter table(:users) do
      add :username, :string
    end

    flush()

    # Migrate nil usernames to email
    from(u in "users",
      update: [set: [username: u.email]],
      where: is_nil(u.username)
    )
    |> Reverie.Repo.update_all([])

    # Set NOT NULL constraint after fixing nulls
    alter table(:users) do
      modify :username, :string, null: false
    end

    # Create a unique username constraint, via index
    create index(:users, [:username], unique: true)
  end
end
