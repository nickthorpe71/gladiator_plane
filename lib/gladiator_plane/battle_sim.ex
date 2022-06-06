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

  defp battle_tick(battle_state) when battle_state.warrior1.battle_stats.current_health <= 0 do
    display_results(battle_state)
    exit(:normal)
  end

  defp battle_tick(battle_state) when battle_state.warrior2.battle_stats.current_health <= 0 do
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
  end

  defp increment_elapsed_time(%{elapsed_time: elapsed_time} = battle_state),
    do: %{battle_state | elapsed_time: elapsed_time + 1}

  defp decrement_warriors_next_action_timer(
         %{warrior1: warrior1, warrior2: warrior2} = battle_state
       ) do
    %{
      battle_state
      | warrior1: %{
          warrior1
          | battle_stats: %{
              warrior1.battle_stats
              | next_action: warrior1.battle_stats.next_action - 1
            }
        },
        warrior2: %{
          warrior2
          | battle_stats: %{
              warrior2.battle_stats
              | next_action: warrior2.battle_stats.next_action - 1
            }
        }
    }
  end

  defp increment_warrior_endurence(%{warrior1: warrior1, warrior2: warrior2} = battle_state) do
    %{
      battle_state
      | warrior1: warrior1 |> adjust_warrior_endurance(endurance_regen(warrior1.base_stats)),
        warrior2: warrior2 |> adjust_warrior_endurance(endurance_regen(warrior2.base_stats))
    }
  end

  defp apply_actions(%{warrior1: warrior1, warrior2: warrior2} = battle_state)
       when warrior1.battle_stats.next_action <= 0 and
              warrior1.battle_stats.current_endurance > 0 and
              warrior2.battle_stats.next_action <= 0 and
              warrior2.battle_stats.current_endurance > 0 do
    %{
      battle_state
      | warrior1: warrior1 |> adjust_warrior_next_action(action_frequency(warrior1.base_stats)),
        warrior2: warrior2 |> adjust_warrior_next_action(action_frequency(warrior2.base_stats))
    }
    |> attempt_attack(:warrior1_attacking)
    |> attempt_attack(:warrior2_attacking)
  end

  defp apply_actions(%{warrior1: warrior1} = battle_state)
       when warrior1.battle_stats.next_action <= 0 and
              warrior1.battle_stats.current_endurance > 0 do
    %{
      battle_state
      | warrior1: warrior1 |> adjust_warrior_next_action(action_frequency(warrior1.base_stats))
    }
    |> attempt_attack(:warrior1_attacking)
  end

  defp apply_actions(%{warrior2: warrior2} = battle_state)
       when warrior2.battle_stats.next_action <= 0 and
              warrior2.battle_stats.current_endurance > 0 do
    %{
      battle_state
      | warrior2: warrior2 |> adjust_warrior_next_action(action_frequency(warrior2.base_stats))
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
    attacker = adjust_warrior_endurance(attacker, endurance_cost_attack(attacker.base_stats))
    damage = damage(defender.base_stats, attacker.base_stats)

    defender =
      if attack_does_hit(defender.base_stats, attacker.base_stats) == true do
        IO.puts(
          "#{attacker.base_stats.first_name} did #{damage} to #{defender.base_stats.first_name}"
        )

        adjsut_warrior_health(defender, -damage)
      else
        IO.puts("#{attacker.base_stats.first_name} missed!")
        defender
      end

    %{battle_state | warrior1: attacker, warrior2: defender}
  end

  defp attempt_attack(
         %{warrior2: attacker, warrior1: defender} = battle_state,
         :warrior2_attacking
       ) do
    attacker = adjust_warrior_endurance(attacker, endurance_cost_attack(attacker.base_stats))
    damage = damage(defender.base_stats, attacker.base_stats)

    defender =
      if attack_does_hit(defender.base_stats, attacker.base_stats) == true do
        IO.puts(
          "#{attacker.base_stats.first_name} did #{damage} to #{defender.base_stats.first_name}"
        )

        adjsut_warrior_health(defender, -damage)
      else
        IO.puts("#{attacker.base_stats.first_name} missed!")
        defender
      end

    %{battle_state | warrior2: attacker, warrior1: defender}
  end

  defp adjsut_warrior_health(warrior, to_adjust_by) do
    %{
      warrior
      | battle_stats: %{
          warrior.battle_stats
          | current_health: warrior.battle_stats.current_health + to_adjust_by
        }
    }
  end

  defp adjust_warrior_endurance(warrior, to_adjust_by) do
    %{
      warrior
      | battle_stats: %{
          warrior.battle_stats
          | current_endurance: warrior.battle_stats.current_endurance + to_adjust_by
        }
    }
  end

  defp adjust_warrior_next_action(warrior, to_adjust_by) do
    %{
      warrior
      | battle_stats: %{
          warrior.battle_stats
          | next_action: warrior.battle_stats.next_action + to_adjust_by
        }
    }
  end

  defp init_battle_state(length, warrior1, warrior2) do
    %{
      elapsed_time: 0,
      battle_length: length,
      warrior1: %{base_stats: warrior1, battle_stats: init_warrior_battle_stats(warrior1)},
      warrior2: %{base_stats: warrior2, battle_stats: init_warrior_battle_stats(warrior2)},
      winner: nil,
      loser: nil
    }
  end

  defp init_warrior_battle_stats(warrior) do
    %{
      next_action: action_frequency(warrior),
      current_health: warrior.max_health,
      current_endurance: warrior.max_endurance,
      damage_done: 0,
      total_attacks: 0,
      number_of_hits: 0,
      number_of_misses: 0,
      number_of_crits: 0,
      score: 0
    }
  end

  defp display_battle_state(%{warrior1: warrior1, warrior2: warrior2}) do
    IO.puts("--------")

    IO.puts(
      "#{warrior1.base_stats.first_name} HP: #{warrior1.base_stats.current_health} END: #{warrior1.base_stats.current_endurance} | #{warrior2.base_stats.first_name} HP: #{warrior2.base_stats.current_health} END: #{warrior2.base_stats.current_endurance}"
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

  def crit_damage(warrior) do
    if did_crit(warrior) do
      IO.puts("#{warrior.first_name} landed a cirtical hit!")
      warrior.power * rand_float(0.9, 1 + warrior.ambition / 25)
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

  def action_frequency(%{speed: speed, ambition: ambition}),
    do: 20 - speed / 10 - ambition / 11

  # def stat_estimation_accuracy(%{intelligence: intelligence}),
  #   do: intelligence / 100 * rand_float(0.85, 1.15)

  # def defender_can_react(defender, attacker),
  #   do: defender.speed / attacker.speed * defender.reflex * rand_float(0.85, 1.15) > 50

  def attack_does_hit(defender, attacker),
    do: attacker.accuracy / defender.reflex * rand_float(0.5, 3) >= 1
end
