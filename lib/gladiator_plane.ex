defmodule GladiatorPlane do
  alias GladiatorPlane.Warrior.Generator, as: WarriorGen
  alias GladiatorPlane.Battle.Simulation, as: BattleSim
  # 1. generate random warriors
  # 2. make warriors able to fight
  # 3. make warriors able to breed

  def run do
    warrior1 = WarriorGen.random_warrior_struct()
    warrior2 = WarriorGen.random_warrior_struct()

    # BattleSim.start_battle(warrior1, warrior2)
    BattleSim.start()
  end
end
