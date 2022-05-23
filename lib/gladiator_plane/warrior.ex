defmodule GladiatorPlane.Warrior do
  use Ecto.Schema

  schema "warriors" do
    field(:user_id, :id)
    field(:first_name)
    field(:last_name)
    field(:nickname)
    field(:age)
    field(:reproduction_side)
    field(:height)
    field(:weight)
    field(:primary_fighting_style)
    field(:fruit_of_eden_id, :id)
    field(:parentA_id, :id)
    field(:parentB_id, :id)
    field(:mutation_factor)
    field(:kills)
    field(:wins)
    field(:losses)
    field(:total_damage_done)
    field(:ambition)
    field(:intelligence)
    field(:healthCapacity)
    field(:enduranceCapacity)
    field(:endurance)
    field(:flexibility)
    field(:strength)
    field(:accuracy)
    field(:dexterity)
    field(:reflex)
    field(:speed)

    timestamps()
  end
end
