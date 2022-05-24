defmodule NameGen do
  def gen_name(length) do
    0..length
    |> Enum.map(fn x -> alternate_rand_char(x) end)
    |> to_string()
    |> String.capitalize()
  end

  def alternate_rand_char(n) when rem(n, 2) === 0 do
    Enum.random('bcdfghjklmnpqrstvwxyz\'')
  end

  def alternate_rand_char(_) do
    Enum.random('aeiou')
  end
end
