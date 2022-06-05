defmodule GladiatorPlane do
  alias GladiatorPlane.Warrior.Generator, as: WarriorGen
  alias GladiatorPlane.Battle.Simulation, as: BattleSim
  # TODO:
  # track fight metadata
  #   - move current health/endurance to metadata
  # update battle_state on end (winner/loser)
  # add scoring to battle
  # if a warrior goes below a percentage of health we should check for a knockout or forefeit
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
    BattleSim.start(warrior1, warrior2, 60 * 30)
  end
end

# GladiatorPlane.run
