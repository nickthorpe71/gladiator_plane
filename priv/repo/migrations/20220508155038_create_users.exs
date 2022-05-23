defmodule GladiatorPlane.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :about, :text
      add :username, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:email, :username])
    create unique_index(:users, [:username, :username])
  end
end
