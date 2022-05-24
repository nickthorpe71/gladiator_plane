defmodule GladiatorPlane.Warrior do
  use Ecto.Schema

  schema "warriors" do
    field(:user_id, :id)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:nickname, :string)
    field(:age, :integer)
    field(:reproduction_side, :string)
    field(:height, :float)
    field(:weight, :float)
    field(:primary_fighting_style, :string)
    field(:fruit_of_eden_id, :id)
    field(:parentA_id, :id)
    field(:parentB_id, :id)
    field(:mutation_factor, :float)
    field(:kills, :integer)
    field(:wins, :integer)
    field(:losses, :integer)
    field(:total_damage_done, :float)
    field(:ambition, :integer)
    field(:intelligence, :integer)
    field(:healthCapacity, :integer)
    field(:enduranceCapacity, :integer)
    field(:endurance, :integer)
    field(:flexibility, :integer)
    field(:strength, :integer)
    field(:accuracy, :integer)
    field(:dexterity, :integer)
    field(:reflex, :integer)
    field(:speed, :integer)

    timestamps()
  end
end
