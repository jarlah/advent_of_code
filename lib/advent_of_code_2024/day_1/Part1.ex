defmodule AdventOfCode2024.Day1.Part1.Solution do
  import AdventOfCode2024.Day1.Input, only: [parsed_input: 0]

  def solution do
    with [list1, list2] <- parsed_input(),
         sorted_list1 <- list1 |> Enum.sort(),
         sorted_list2 <- list2 |> Enum.sort() do
      Enum.zip(sorted_list1, sorted_list2)
      |> Enum.map(fn {first, second} -> abs(first - second) end)
      |> Enum.sum()
    end
  end
end
