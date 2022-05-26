defmodule GladiatorPlane.Battle do
  use Ecto.Schema

  schema "battle" do
    field(:combatant1_id, :id)
    field(:combatant2_id, :id)
    field(:winner_id, :id)
    field(:loser_id, :id)

    timestamps()
  end
end
