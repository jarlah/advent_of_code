defmodule AOC2024.Day7.Part2.Solution do
  @doc ~S"""
  ## Examples

      #iex> AOC2024.Day7.Part2.Solution.solution(AOC2024.Day7.Input.input())
      #0

      #iex> AOC2024.Day7.Part2.Solution.solution(AOC2024.Day7.Input.test_input())
      #0

  """
  def solution(input),
    do: AOC2024.Day7.Part1.Solution.solution(input, AOC2024.Day7.Input.special_operators(), "0")
end
