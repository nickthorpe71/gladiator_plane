defmodule GA do
  # this is the function we are trying to optimize
  # the AI is trying to find the inputs that make
  # :math.pow(6*x, 3) + :math.pow(9*y, 2) + 90*z return 25
  def opt(x,y,z) do
    :math.pow(6*x, 3) + :math.pow(9*y, 2) + 90*z - 25
  end

  def fitness(x,y,z) do
    # run the function we are trying to optimize
    result = opt(x,y,z)

    # rank the result based on how close we get to 0
    # if we hit zero then we've found the 3 params that
    # cause the equation :math.pow(6*x, 3) + :math.pow(9*y, 2) + 90*z
    # to equal 25
    # we divide 1 by the result because the lower the result is the
    # larger the number will be that is produced by 1/result
    case result do
      0 -> 99999
      _ -> abs(1/result)
    end
  end

  def generate_solutions() do
    0..10
    |> Enum.map(fn(_) -> { :rand.uniform(10000), :rand.uniform(10000), :rand.uniform(10000) } end)
  end

  def rank_solutions(solutions) do
    solutions
    |> Enum.map(fn(solution) -> {fitness(elem(solution, 0), elem(solution, 1), elem(solution, 2)), solution} end)
    |> Enum.sort()
    |> Enum.reverse()
  end

  def run() do
    generate_solutions()
    |> rank_solutions()
    |> Enum.slice(0, 100)
    |> Enum.reduce([], fn topSolution, acc -> [elem(topSolution, 1) | acc] end )
  end
end

IO.puts(GA.run())
