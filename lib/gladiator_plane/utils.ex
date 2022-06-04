defmodule GladiatorPlane.Utils do
  def rand_float(min, max) do
    Enum.random(trunc(min * 100)..trunc(max * 100)) / 100
  end
end
