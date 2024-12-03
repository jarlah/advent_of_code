defmodule AOC2024.Day1.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day1.Part2.Solution.solution(AOC2024.Day1.Input.test_input())
      31

  """
  def solution(parsed_input) do
    with [list1, list2] <- parsed_input do
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
