defmodule GladiatorPlane.Battle.Simulation do
  import GladiatorPlane.Utils, only: [rand_float: 2]
  use GenServer

  @battle_rate 10

  def start(warrior1, warrior2, battle_length) do
    GenServer.start(
      GladiatorPlane.Battle.Simulation,
      init_battle_state(battle_length, warrior1, warrior2)
    )
  end

  @impl true
  def init(state) do
    :timer.send_interval(@battle_rate, :tick)
    {:ok, state}
  end

  @impl true
  def handle_info(:tick, state) do
    display_battle_state(state)
    {:noreply, battle_tick(state)}
  end

  defp battle_tick(%{warrior1: %{current_health: current_health}} = battle_state)
       when current_health <= 0 do
    display_results(battle_state)
    exit(:normal)
  end

  defp battle_tick(%{warrior2: %{current_health: current_health}} = battle_state)
       when current_health <= 0 do
    display_results(battle_state)
    exit(:normal)
  end

  defp battle_tick(%{elapsed_time: elapsed_time, battle_length: battle_length} = battle_state)
       when elapsed_time >= battle_length do
    display_results(battle_state)
    exit(:normal)
  end

  defp battle_tick(battle_state) do
    battle_state
    |> increment_elapsed_time
    |> decrement_warriors_next_action_timer
    |> apply_actions
    |> increment_warrior_endurence

    # reduce endruance of attacker
    # if a warrior acts check if the other warripr can react
    # if the other warrior can react then play that action
    # repeat

    # battle_state = %{battle_state | winner: battle_state[:warrior1]}
    # battle_state = %{battle_state | loser: battle_state[:warrior2]}
  end

  defp increment_elapsed_time(%{elapsed_time: elapsed_time} = battle_state),
    do: %{battle_state | elapsed_time: elapsed_time + 1}

  defp decrement_warriors_next_action_timer(battle_state) do
    %{
      battle_state
      | warrior1_next_action: battle_state.warrior1_next_action - 1,
        warrior2_next_action: battle_state.warrior2_next_action - 1
    }
  end

  defp increment_warrior_endurence(%{warrior1: warrior1, warrior2: warrior2} = battle_state) do
    %{
      battle_state
      | warrior1: %{
          warrior1
          | current_endurance: warrior1.current_endurance + endurance_regen(warrior1)
        },
        warrior2: %{
          warrior2
          | current_endurance: warrior2.current_endurance + endurance_regen(warrior2)
        }
    }
  end

  defp apply_actions(battle_state)
       when battle_state.warrior1_next_action <= 0 and battle_state.warrior1.current_endurance > 0 and
              battle_state.warrior2_next_action <= 0 and
              battle_state.warrior2.current_endurance > 0 do
    %{
      battle_state
      | warrior1_next_action: action_frequency(battle_state.warrior1),
        warrior2_next_action: action_frequency(battle_state.warrior2)
    }
    |> attempt_attack(:warrior1_attacking)
    |> attempt_attack(:warrior2_attacking)
  end

  defp apply_actions(battle_state)
       when battle_state.warrior1_next_action <= 0 and battle_state.warrior1.current_endurance > 0 do
    %{
      battle_state
      | warrior1_next_action: action_frequency(battle_state.warrior1)
    }
    |> attempt_attack(:warrior1_attacking)
  end

  defp apply_actions(battle_state)
       when battle_state.warrior2_next_action <= 0 and battle_state.warrior2.current_endurance > 0 do
    %{
      battle_state
      | warrior2_next_action: action_frequency(battle_state.warrior2)
    }
    |> attempt_attack(:warrior2_attacking)
  end

  defp apply_actions(battle_state) do
    battle_state
  end

  defp attempt_attack(
         %{warrior1: attacker, warrior2: defender} = battle_state,
         :warrior1_attacking
       ) do
    # reduce attackers endurance
    attacker = %{
      attacker
      | current_endurance: attacker.current_endurance - endurance_cost_attack(attacker)
    }

    defender =
      if attack_does_hit(defender, attacker) == true do
        apply_attack_damage(defender, attacker)
      else
        IO.puts("#{attacker.first_name} missed!")
        defender
      end

    %{battle_state | warrior1: attacker, warrior2: defender}
  end

  defp attempt_attack(
         %{warrior2: attacker, warrior1: defender} = battle_state,
         :warrior2_attacking
       ) do
    # reduce attackers endurance
    attacker = %{
      attacker
      | current_endurance: attacker.current_endurance - endurance_cost_attack(attacker)
    }

    defender =
      if attack_does_hit(defender, attacker) == true do
        apply_attack_damage(defender, attacker)
      else
        IO.puts("#{attacker.first_name} missed!")
        defender
      end

    %{battle_state | warrior2: attacker, warrior1: defender}
  end

  defp apply_attack_damage(defender, attacker) do
    IO.puts("#{attacker.first_name} did #{damage(defender, attacker)} to #{defender.first_name}")

    %{
      defender
      | current_health: defender.current_health - damage(defender, attacker)
    }
  end

  defp init_battle_state(length, warrior1, warrior2) do
    %{
      elapsed_time: 0,
      battle_length: length,
      warrior1: warrior1,
      warrior2: warrior2,
      warrior1_next_action: action_frequency(warrior1),
      warrior2_next_action: action_frequency(warrior2),
      winner: nil,
      loser: nil
    }
  end

  defp display_battle_state(%{warrior1: warrior1, warrior2: warrior2}) do
    IO.puts("--------")

    IO.puts(
      "#{warrior1.first_name} HP: #{warrior1.current_health} END: #{warrior1.current_endurance} | #{warrior2.first_name} HP: #{warrior2.current_health} END: #{warrior2.current_endurance}"
    )
  end

  defp display_results(battle_state) do
    IO.inspect(battle_state)
  end

  # Battle Calculations
  def damage(defender, attacker) do
    attacker.power / defender.toughness * 10 + 2 +
      crit_damage(attacker) * rand_float(0.85, 1.15)
  end

  def crit_damage(%{power: power, ambition: ambition} = warrior) do
    if did_crit(warrior) do
      IO.puts("#{warrior.first_name} landed a cirtical hit!")
      power * rand_float(0.9, 1 + ambition / 25)
    else
      0
    end
  end

  defp did_crit(warrior) do
    crit_chance(warrior) > 0.9
  end

  def crit_chance(warrior) do
    warrior.accuracy * warrior.dexterity * warrior.reflex * warrior.ambition *
      warrior.intelligence / 9_000_000 * rand_float(0.6, 2) / 100
  end

  def endurance_regen(%{endurance: endurance}) do
    3 + endurance / 20 * rand_float(0.85, 1.15)
  end

  def endurance_cost_attack(%{endurance: endurance}) do
    100 - endurance * rand_float(0.5, 1)
  end

  # def endurance_cost_block(%{endurance: endurance, toughness: toughness}) do
  #   (endurance - toughness) / 10 * rand_float(0.85, 1.15)
  # end

  # def endurance_cost_dodge(%{endurance: endurance, reflex: reflex, speed: speed}) do
  #   abs((endurance - reflex / 2 - speed / 2) / 10 * rand_float(0.85, 1.15))
  # end

  # def counter_chance_block(%{
  #       strength: strength,
  #       toughness: toughness,
  #       reflex: reflex,
  #       intelligence: intelligence
  #     }) do
  #   (strength + toughness + reflex + intelligence) / 500
  # end

  # def counter_chance_dodge(%{
  #       speed: speed,
  #       dexterity: dexterity,
  #       reflex: reflex,
  #       intelligence: intelligence
  #     }) do
  #   (speed + dexterity + reflex + intelligence) / 500
  # end

  def action_frequency(%{speed: speed, ambition: ambition}), do: 20 - speed / 10 - ambition / 11

  # def stat_estimation_accuracy(%{intelligence: intelligence}),
  #   do: intelligence / 100 * rand_float(0.85, 1.15)

  # def defender_can_react(defender, attacker),
  #   do: defender.speed / attacker.speed * defender.reflex * rand_float(0.85, 1.15) > 50

  def attack_does_hit(defender, attacker),
    do: attacker.accuracy / defender.reflex * rand_float(0.5, 3) >= 1
end
