defmodule AOC2024.Day8.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day8.Part2.Solution.solution(AOC2024.Day8.Input.test_input())
      34
      iex> AOC2024.Day8.Part2.Solution.solution(AOC2024.Day8.Input.input())
      839

  """
  def solution(input), do: AOC2024.Day8.Part1.Solution.solution(input, true)
end
