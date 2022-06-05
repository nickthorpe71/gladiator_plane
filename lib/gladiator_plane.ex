defmodule GladiatorPlane do
  alias GladiatorPlane.Warrior.Generator, as: WarriorGen
  alias GladiatorPlane.Battle.Simulation, as: BattleSim
  # TODO:
  # health should get a buff from weight and height
  # endurance should take a hit from being "overweight" (weight compared to height ratio)
  # track fight metadata
  #   - move current health/endurance to metadata
  # update battle_state on end (winner/loser)
  # add scoring to battle
  # reduce endurance when warriors fight
  # create tournament and display result
  # make warriors able to breed
  #   - After each fight they "breed" with their opponent over and over again until the new version of themself beats the old version. This represents them growing from the battle. Their battle brain should persist through each of these battles growing along the way.
  # add choices for warriors (action: attack, bide / reaction: block, dodge )
  # add warrior brain during batter
  # add post battle evolution
  # reimplement database
  # create UI

  def run do
    warrior1 = WarriorGen.random_warrior_struct()
    warrior2 = WarriorGen.random_warrior_struct()

    # BattleSim.start_battle(warrior1, warrior2)
    BattleSim.start(warrior1, warrior2, 60 * 4)
  end
end

# GladiatorPlane.run
