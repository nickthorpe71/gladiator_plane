defmodule GladiatorPlane do
  # 1. generate random warriors
  # 2. make warriors able to fight
  # 3. make warriors able to breed

  # Later
  # 4. warriors roam plane
  # 5. fruit spawns on plane
  # 6. warriors wander plane, eat fruit, fight, breed, and evolve

  def run do
    GladiatorPlane.Repo.Seed.seed_all()
  end
end
