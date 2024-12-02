defmodule AdventOfCode2024.Day1.Solution do
  alias AdventOfCode2024.Utils.FileUtils

  def solution do
    with [list1, list2] <- FileUtils.read_numbers(),
         sorted_list1 <- list1 |> Enum.sort(),
         sorted_list2 <- list2 |> Enum.sort() do
      Enum.zip(sorted_list1, sorted_list2)
      |> Enum.map(fn {first, second} -> abs(first - second) end)
      |> Enum.sum()
    end
  end
end
