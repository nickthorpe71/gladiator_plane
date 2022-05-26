defmodule GladiatorPlane.WarriorGen do
  import NameGen
  alias GladiatorPlane.Warrior

  def rand_float(min, max) do
    Enum.random(trunc(min * 100)..trunc(max * 100)) / 100
  end

  def random_warrior_struct do
    height = Enum.random(65..250) + :rand.uniform()
    weight = Enum.random(70..400) + :rand.uniform()

    endurence =
      Enum.random(1..90) - weight * rand_float(0, 0.075) - height * rand_float(0, 0.1) + 25

    intelligence = Enum.random(1..100)
    accuracy = (Enum.random(1..75) + intelligence / 4) * rand_float(0.85, 1.15)
    flexibility = Enum.random(1..100) - weight * rand_float(0, 0.075)
    dexterity = Enum.random(1..75) + accuracy / 4 * rand_float(0.85, 1.15)

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
      ambition: Enum.random(1..100),
      intelligence: intelligence,
      healthCapacity: Enum.random(100..1000),
      enduranceCapacity: endurence * 9 * rand_float(0.85, 1.15) + 100,
      endurance: endurence,
      flexibility: flexibility,
      strength: (Enum.random(1..50) + weight / 40 + height / 8) * rand_float(0.85, 1.15),
      accuracy: accuracy,
      dexterity: dexterity,
      reflex:
        Enum.random(1..50) + flexibility / 4 + dexterity / 4 - weight * rand_float(0, 0.075) -
          height * rand_float(0, 0.1),
      speed: Enum.random(1..100) - weight * rand_float(0, 0.075) - height * rand_float(0, 0.1)
    }

    new_warrior
  end

  def random_warrior_schema do
    %Warrior{
      first_name: Enum.random(1..6) |> gen_name(),
      last_name: Enum.random(1..10) |> gen_name(),
      nickname: Enum.random(1..10) |> gen_name(),
      age: Enum.random(1..1111),
      reproduction_side: choose_reproduction(),
      height: Enum.random(1..200) + :rand.uniform(),
      weight: Enum.random(1..1000) + :rand.uniform(),
      mutation_factor: :rand.uniform(),
      kills: 0,
      wins: 0,
      losses: 0,
      total_damage_done: 0.0,
      ambition: Enum.random(1..1000),
      intelligence: Enum.random(1..1000),
      healthCapacity: Enum.random(1..1000),
      enduranceCapacity: Enum.random(1..1000),
      endurance: Enum.random(1..1000),
      flexibility: Enum.random(1..1000),
      strength: Enum.random(1..1000),
      accuracy: Enum.random(1..1000),
      dexterity: Enum.random(1..1000),
      reflex: Enum.random(1..1000),
      speed: Enum.random(1..1000)
    }
  end

  def random_warrior(num_to_gen) do
    Enum.map(1..num_to_gen, fn _ -> random_warrior_struct() end)
  end

  def choose_reproduction do
    if :rand.uniform(2) === 1, do: "A", else: "B"
  end
end
