defmodule AOC2024.Day6.Part2.Solution do
  alias AOC2024.Day6.Tile
  alias AOC2024.Day6.TileParser
  alias AOC2024.Day6.TileFormatter
  alias AOC2024.Day6.TileTraverser

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part2.Solution.solution(AOC2024.Day6.Input.test_obstacle_input(), true, true)
      31

  """
  def solution(input, print_tiles \\ false, should_cycle \\ false) do
    map = TileParser.parse(input)

    {status, map} = TileTraverser.traverse_map(map, Enum.find(map, &Tile.is_guard/1))

    if should_cycle && status !== :cycling,
      do: raise("Did not cycle"),
      else: nil

    if print_tiles,
      do: TileFormatter.print_grid(map, hd(input) |> String.length()),
      else: nil

    Enum.count(map, fn %Tile{visited: visited} -> visited end)
  end
end
