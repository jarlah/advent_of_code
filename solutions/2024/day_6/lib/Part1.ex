defmodule AOC2024.Day6.Part1.Solution do
  alias AOC2024.Day6.Tile
  alias AOC2024.Day6.TileParser
  alias AOC2024.Day6.TileTraverser

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.test_input())
      41
      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.input())
      5131

  """
  def solution(input) do
    map = input |> TileParser.parse()

    {_, guard} = Enum.find(map, fn {_, tile} -> Tile.is_guard(tile) end)

    map = TileTraverser.traverse_map(map, guard)

    # TileFormatter.print_grid(map, hd(input) |> String.length())

    Enum.count(map, fn {_, %Tile{visited: visited}} -> visited end)
  end
end
