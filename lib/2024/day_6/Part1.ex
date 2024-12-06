defmodule AOC2024.Day6.Part1.Solution do
  alias AOC2024.Day6.Tile
  alias AOC2024.Day6.TileParser
  alias AOC2024.Day6.TileFormatter
  alias AOC2024.Day6.TileTraverser

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.test_input(), true)
      41

      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.input())
      5131

  """
  def solution(input, print_tiles \\ false) do
    map = TileParser.parse(input)

    map = TileTraverser.traverse_map(map, Enum.find(map, &Tile.is_guard/1))

    if print_tiles,
      do: map |> TileFormatter.print_grid(hd(input) |> String.length()),
      else: nil

    Enum.count(map, fn %Tile{visited: visited} -> visited end)
  end
end
