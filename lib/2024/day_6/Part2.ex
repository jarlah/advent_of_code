defmodule AOC2024.Day6.Part2.Solution do
  alias AOC2024.Day6.Tile
  alias AOC2024.Day6.TileParser
  alias AOC2024.Day6.TileTraverser

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part2.Solution.solution(AOC2024.Day6.Input.test_input())
      6
      iex> AOC2024.Day6.Part2.Solution.solution(AOC2024.Day6.Input.input())
      1784

  """
  def solution(input) do
    map = input |> TileParser.parse()

    {_, guard} = Enum.find(map, fn {_, tile} -> Tile.is_guard(tile) end)

    # start = System.monotonic_time(:microsecond)

    result =
      map
      |> TileTraverser.traverse_map(guard)
      |> Map.filter(fn {_, tile} -> tile.visited end)
      |> Map.keys()
      |> Enum.map(fn pos -> Map.replace(map, pos, Tile.new_obstacle(pos)) end)
      |> Enum.map(fn map -> cycling?(map, guard) end)
      |> Enum.filter(& &1)
      |> Enum.count()

    # elapsed = System.monotonic_time(:microsecond) - start
    # IO.puts("Finished in #{elapsed / 1000}ms")

    result
  end

  defp cycling?(map, guard, visited \\ MapSet.new()) do
    if MapSet.member?(visited, {guard.pos, guard.direction}) do
      true
    else
      try do
        cycling?(
          map,
          move_guard(map, guard),
          MapSet.put(visited, {guard.pos, guard.direction})
        )
      rescue
        KeyError ->
          false
      end
    end
  end

  defp move_guard(map, guard) do
    new_guard = guard |> Tile.move()

    if Map.get(map, new_guard.pos).is_obstacle do
      guard |> Tile.turn()
    else
      new_guard
    end
  end
end
