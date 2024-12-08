defmodule AOC2024.Day8.Part1.Solution do
  alias AOC2024.Day8.TileParser
  alias AOC2024.Day8.TileFormatter

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day8.Part1.Solution.solution(AOC2024.Day8.Input.test_input())
      0

  """
  def solution(input) do
    width = input |> hd() |> String.to_charlist() |> length()

    input
    |> TileParser.parse()
    |> then(&TileFormatter.print_grid(&1, width))

    0
  end
end
