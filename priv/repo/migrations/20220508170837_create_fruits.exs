defmodule GladiatorPlane.Repo.Migrations.CreateFruits do
  use Ecto.Migration

  def change do
    create table(:fruits) do
      add :name, :string
      add :nutrition_value, :string
      add :rarity, :string
      add :mutation, :string
      add :ambition_buff, :integer
      add :intelligence_buff, :integer
      add :healthCapacity_buff, :integer
      add :enduranceCapacity_buff, :integer
      add :endurance_buff, :integer
      add :flexibility_buff, :integer
      add :strength_buff, :integer
      add :accuracy_buff, :integer
      add :dexterity_buff, :integer
      add :reflex_buff, :integer
      add :speed_buff, :integer

      timestamps()
    end
  end
end
