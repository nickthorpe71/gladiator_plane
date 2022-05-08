defmodule GladiatorPlane.Repo.Migrations.AddBattles do
  use Ecto.Migration

  def change do
    create table(:battles) do
      add :combatant1_id, references(:warriors, on_delete: :delete_all)
      add :combatant2_id, references(:warriors, on_delete: :delete_all)
      add :winner_id, references(:warriors, on_delete: :delete_all)
      add :loser_id, references(:warriors, on_delete: :delete_all)

      timestamps()
    end
  end
end
