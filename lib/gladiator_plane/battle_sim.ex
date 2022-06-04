defmodule GladiatorPlane.Battle.Simulation do
  import GladiatorPlane.Utils, only: [rand_float: 2]

  def start_battle(warrior1, warrior2) do
    # Process.send_after(self(), :ping, 1000)

    init_battle_state(100, warrior1, warrior2) |> battle_tick()
  end

  defp battle_tick(%{warrior1: %{current_health: current_health}} = battle_state)
       when current_health <= 0 do
    battle_state = %{battle_state | winner: battle_state[:warrior2]}
    battle_state = %{battle_state | loser: battle_state[:warrior1]}

    battle_state
  end

  defp battle_tick(%{warrior2: %{current_health: current_health}} = battle_state)
       when current_health <= 0 do
    battle_state = %{battle_state | winner: battle_state[:warrior1]}
    battle_state = %{battle_state | loser: battle_state[:warrior2]}

    battle_state
  end

  defp battle_tick(%{elapsed_time: elapsed_time, battle_length: battle_length} = battle_state)
       when elapsed_time >= battle_length do
    battle_state
  end

  defp battle_tick(battle_state) do
    battle_state = %{battle_state | elapsed_time: battle_state[:elapsed_time] + 1}

    # check if either warrior can act
    # if a warrior can act then apply that action

    new_warrior1_health = battle_state[:warrior1][:current_health] - 1
    new_warrior2_health = battle_state[:warrior2][:current_health] - 1

    battle_state = %{
      battle_state
      | warrior1: %{
          battle_state[:warrior1]
          | current_health: new_warrior1_health
        }
    }

    battle_state = %{
      battle_state
      | warrior2: %{
          battle_state[:warrior2]
          | current_health: new_warrior2_health
        }
    }

    battle_tick(battle_state)
  end

  defp init_battle_state(length, warrior1, warrior2) do
    %{
      elapsed_time: 0,
      battle_length: length,
      warrior1: warrior1,
      warrior2: warrior2,
      winner: nil,
      loser: nil
    }
  end

  # Battle Calculations
  def damage(attacker, defender),
    do: attacker.power / defender.toughness + 2 + crit_damage(attacker) + rand_float(0.85, 1.15)

  def crit_damage(%{power: power}), do: power * rand_float(0.85, 1.15)

  def crit_chance(warrior) do
    warrior.accuracy * warrior.dexterity * warrior.reflex * warrior.ambition *
      warrior.intelligence / 10_000_000 / 2 * rand_float(0.85, 1.15) / 100
  end

  def endurance_cost_attack(%{endurance: endurance}, attack_damage) do
    endurance * attack_damage / 100 * rand_float(0.85, 1.15)
  end

  def endurance_cost_block(%{endurance: endurance, toughness: toughness}) do
    (endurance - toughness) / 10 * rand_float(0.85, 1.15)
  end

  # def endurance_cost_dodge(%{endurance: endurance, reflex: reflex, speed: speed}) do
  #   (endurance - toughness) / 10 * rand_float(0.85, 1.15)
  # end

  # endurance_cost_dodge = abs(endurance - reflex/2 - speed/2) / 10 * rand(0.85, 1.15)
  # counter_chance_block = (strength + toughness + reflex + intelligence) / 500
  # counter_chance_dodge = (speed + dexterity + reflex + intelligence) / 500
  # action_frequency = (how many seconds before next attack) 10 - speed/20 - ambition/25
  # stat_estimation_accuracy = intelligence / 100 * rand(0.85, 1.15)
  # defender_can_react = (defender_speed / attacker_speed * defender_reflex * rand(0.85, 1.15)) > 50
  # does_attack_hit = (attacker_accuracy / defender_reflex * rand(0.75, 1.25)) >= 1
end
