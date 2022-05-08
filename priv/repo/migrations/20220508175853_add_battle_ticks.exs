defmodule GladiatorPlane.Repo.Migrations.AddBattleTicks do
  use Ecto.Migration

  def change do
    create table(:battle_ticks) do
      add :battle_id, references(:battles, on_delete: :delete_all)
      add :combatant1_action, :string
      add :combatant2_action, :string
      add :combatant1_health, :integer
      add :combatant2_health, :integer
      add :combatant1_endurance, :integer
      add :combatant2_endurance, :integer

      timestamps()
    end
  end
end
