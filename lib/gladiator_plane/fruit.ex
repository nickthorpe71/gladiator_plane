defmodule GladiatorPlane.Fruit do
  use Ecto.Schema

  schema "fruits" do
    field(:name)
    field(:nutrition_value)
    field(:rarity)
    field(:mutation)
    field(:ambition_buff)
    field(:intelligence_buff)
    field(:healthCapacity_buff)
    field(:enduranceCapacity_buff)
    field(:endurance_buff)
    field(:flexibility_buff)
    field(:strength_buff)
    field(:accuracy_buff)
    field(:dexterity_buff)
    field(:reflex_buff)
    field(:speed_buff)

    timestamps()
  end
end
