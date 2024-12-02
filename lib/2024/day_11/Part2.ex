defmodule AOC2024.Day11.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day11.Part2.Solution.solution(AOC2024.Day11.Input.input(), 50, true)
      6403575694
      iex> AOC2024.Day11.Part2.Solution.solution(AOC2024.Day11.Input.input(), 75)
      221280540398419

  """
  def solution(input, num, log \\ false) do
    AOC2024.Day11.Part1.Solution.solution(input, num, log)
  end
end
