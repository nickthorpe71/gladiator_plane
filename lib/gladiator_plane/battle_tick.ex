defmodule GladiatorPlane.BattleTick do
  use Ecto.Schema

  schema "battle_ticks" do
    field(:battle_id, :id)
    field(:tick_number)
    field(:combatant1_action)
    field(:combatant2_action)
    field(:combatant1_health)
    field(:combatant2_health)
    field(:combatant1_endurance)
    field(:combatant2_endurance)

    timestamps()
  end
end
