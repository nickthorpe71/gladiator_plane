defmodule GladiatorPlane.Warrior.Generator do
  import NameGen
  alias GladiatorPlane.Warrior
  import GladiatorPlane.Utils, only: [rand_float: 2]

  def random_warrior_struct do
    height = Enum.random(65..250) + :rand.uniform()
    weight = Enum.random(70..400) + :rand.uniform() + height / 5

    endurance =
      Enum.random(5..75) - weight * rand_float(0, 0.075) - height * rand_float(0, 0.1) + 25

    intelligence = Enum.random(10..100)
    strength = (Enum.random(2..50) + weight / 40 + height / 8) * rand_float(0.85, 1.15)
    speed = Enum.random(25..100) - weight * rand_float(0, 0.075) - height * rand_float(0, 0.1)
    ambition = Enum.random(10..100)
    accuracy = (Enum.random(5..75) + intelligence / 4) * rand_float(0.85, 1.15)
    flexibility = Enum.random(5..75) - weight * rand_float(0, 0.075) + 25
    dexterity = Enum.random(5..75) + accuracy / 4 * rand_float(0.85, 1.15)

    max_health = Enum.random(100..1000)
    max_endurance = endurance * 9 * rand_float(0.85, 1.15) + 100

    new_warrior = %{
      first_name: Enum.random(1..6) |> gen_name(),
      last_name: Enum.random(1..10) |> gen_name(),
      nickname: Enum.random(1..10) |> gen_name(),
      age: Enum.random(10..150),
      reproduction_side: choose_reproduction(),
      height: height,
      weight: weight,
      mutation_factor: :rand.uniform(),
      alive: true,
      kills: 0,
      wins: 0,
      losses: 0,
      total_damage_done: 0.0,
      ambition: ambition,
      intelligence: intelligence,
      max_health: max_health,
      current_health: max_health,
      max_endurance: max_endurance,
      current_endurance: max_endurance,
      endurance: endurance,
      flexibility: flexibility,
      strength: strength,
      accuracy: accuracy,
      dexterity: dexterity,
      reflex:
        Enum.random(20..30) + flexibility / 4 + dexterity / 4 - weight * rand_float(0, 0.075) -
          height * rand_float(0, 0.1),
      speed: speed,
      power: strength + speed / 2,
      toughness: strength + ambition / 2
    }

    new_warrior
  end

  def random_warrior(num_to_gen) do
    Enum.map(1..num_to_gen, fn _ -> random_warrior_struct() end)
  end

  def choose_reproduction do
    if :rand.uniform(2) === 1, do: "A", else: "B"
  end
end
