import NameGen

defmodule GladiatorPlane do
  # 1. generate random warriors
  # 2. make warriors able to fight
  # 3. make warriors able to breed

  # Later
  # 4. warriors roam plane
  # 5. fruit spawns on plane
  # 6. warriors wander plane, eat fruit, fight, breed, and evolve

  # https://www.youtube.com/watch?v=XvDShUHWg0Q&list=PLFhQVxlaKQElscjMvMmyMCaZ9mxf4XAw-&ab_channel=AlchemistCamp

  def run do
    :rand.uniform(6) |> gen_name() |> IO.puts()
    :rand.uniform(10) |> gen_name() |> IO.puts()
  end
end
