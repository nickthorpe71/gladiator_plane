defmodule GladiatorPlane.WarriorGen do
  import NameGen
  alias GladiatorPlane.Warrior

  def random_warrior do
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
    Enum.map(1..num_to_gen, fn _ -> random_warrior() end)
  end

  def choose_reproduction do
    if :rand.uniform(2) === 1, do: "A", else: "B"
  end
end
