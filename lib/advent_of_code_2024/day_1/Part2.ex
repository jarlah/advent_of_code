defmodule AdventOfCode2024.Day2.Solution do
  alias AdventOfCode2024.Day1.Input

  def solution do
    with [list1, list2] <- Input.parsed_input() do
      list1
      |> Enum.map(fn number ->
        number *
          (list2
           |> Enum.filter(fn right -> number == right end)
           |> Enum.count())
      end)
      |> Enum.sum()
    end
  end
end
