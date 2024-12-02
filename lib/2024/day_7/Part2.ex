defmodule AOC2024.Day7.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day7.Part2.Solution.solution(AOC2024.Day7.Input.input())
      271691107779347
      iex> AOC2024.Day7.Part2.Solution.solution(AOC2024.Day7.Input.test_input())
      11387

  """
  def solution(input),
    do:
      AOC2024.Day7.Part1.Solution.solution(
        input,
        AOC2024.Day7.OperatorPermutations.special_operators(),
        "2"
      )
end
