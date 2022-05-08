defmodule GladiatorPlane.Repo.Migrations.CreateWarriors do
  use Ecto.Migration

  def change do
    create table(:warriors) do
      add :user_id, references(:users, on_delete: :nilify_all)
      add :first_name, :string
      add :last_name, :string
      add :nickname, :string
      add :age, :integer
      add :reproduction_side, :string
      add :height, :float
      add :weight, :float
      add :primary_fighting_style, :string
      add :fruit_of_eden_id, references(:fruits, on_delete: :nilify_all)
      add :parentA_id, references(:warriors, on_delete: :nilify_all)
      add :parentB_id, references(:warriors, on_delete: :nilify_all)
      add :mutation_factor, :float
      add :kills, :integer
      add :wins, :integer
      add :losses, :integer
      add :total_damage_done, :float
      add :ambition, :integer
      add :intelligence, :integer
      add :healthCapacity, :integer
      add :enduranceCapacity, :integer
      add :endurance, :integer
      add :flexibility, :integer
      add :strength, :integer
      add :accuracy, :integer
      add :dexterity, :integer
      add :reflex, :integer
      add :speed, :integer

      timestamps()
    end
  end
end
