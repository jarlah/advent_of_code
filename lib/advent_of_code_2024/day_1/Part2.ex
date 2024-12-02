defmodule AdventOfCode2024.Day1.Part2.Solution do
  import AdventOfCode2024.Day1.Input, only: [parsed_input: 0]

  def solution do
    with [list1, list2] <- parsed_input() do
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
