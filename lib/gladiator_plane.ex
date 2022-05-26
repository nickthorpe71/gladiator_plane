defmodule GladiatorPlane do
  alias GladiatorPlane.Warrior.Generator, as: WarriorGen
  alias GladiatorPlane.Battle.Simulation, as: BattleSim
  # 1. generate random warriors
  # 2. make warriors able to fight
  # 3. make warriors able to breed

  def run do
    # GladiatorPlane.Repo.Seed.seed_all()
    warrior1 = WarriorGen.random_warrior_struct()
    warrior2 = WarriorGen.random_warrior_struct()

    BattleSim.start_battle(warrior1, warrior2)
  end
end
