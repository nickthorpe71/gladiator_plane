import NameGen
alias GladiatorPlane.Warrior

defmodule GladiatorPlane do
  # 1. generate random warriors
  # 2. make warriors able to fight
  # 3. make warriors able to breed

  # Later
  # 4. warriors roam plane
  # 5. fruit spawns on plane
  # 6. warriors wander plane, eat fruit, fight, breed, and evolve

  def random_warrior do
    new_warrior = %Warrior{
      first_name: :rand.uniform(6) |> gen_name(),
      last_name: :rand.uniform(10) |> gen_name(),
      nickname: :rand.uniform(10) |> gen_name(),
      age: :rand.uniform(1111),
      reproduction_side: :rand.uniform(2),
      height: :rand.uniform(200),
      weight: :rand.uniform(1000),
      primary_fighting_style: nil,
      fruit_of_eden_id: nil,
      parentA_id: nil,
      parentB_id: nil,
      mutation_factor: :rand.uniform(100),
      kills: 0,
      wins: 0,
      losses: 0,
      total_damage_done: 0,
      ambition: :rand.uniform(1000),
      intelligence: :rand.uniform(1000),
      healthCapacity: :rand.uniform(1000),
      enduranceCapacity: :rand.uniform(1000),
      endurance: :rand.uniform(1000),
      flexibility: :rand.uniform(1000),
      strength: :rand.uniform(1000),
      accuracy: :rand.uniform(1000),
      dexterity: :rand.uniform(1000),
      reflex: :rand.uniform(1000),
      speed: :rand.uniform(1000)
    }

    new_warrior
  end

  def run do
    random_warrior() |> IO.puts()
  end
end
