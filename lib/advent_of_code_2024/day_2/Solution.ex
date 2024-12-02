defmodule AdventOfCode2024.Day2.Solution do
  alias AdventOfCode2024.Utils.FileUtils

  def solution do
    with [list1, list2] <- FileUtils.read_numbers() do
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
