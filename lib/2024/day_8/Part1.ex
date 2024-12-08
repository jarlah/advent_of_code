defmodule AOC2024.Day8.Part1.Solution do
  alias AOC2024.Day8.Tile
  alias AOC2024.Day8.TileParser
  alias AOC2024.Day8.TileFormatter

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day8.Part1.Solution.solution(AOC2024.Day8.Input.input())
      0

  """
  def solution(input) do
    width = input |> hd() |> String.to_charlist() |> length()

    map =
      input
      |> TileParser.parse()
      |> tap(&TileFormatter.print_grid(&1, width))

    IO.puts("")

    map
    |> Map.filter(fn {_, value} -> value.is_antenna end)
    |> Map.keys()
    |> Enum.reduce(map, fn pos, acc ->
      tile = Map.get(map, pos)

      IO.inspect("Finding match for #{inspect(pos)}")

      find_matching_antennas(map, tile)
      |> Enum.reduce(acc, fn neighbour, acc ->
        tile = tile |> Tile.set_neighbour(neighbour)
        neighbour = neighbour |> Tile.set_neighbour(tile)
        acc |> Map.replace(neighbour.pos, neighbour) |> Map.replace(tile.pos, tile)
      end)
    end)
    |> tap(&TileFormatter.print_grid(&1, width))

    0
  end

  def find_matching_antennas(map, start_antenna) do
    start = System.monotonic_time(:microsecond)

    directions =
      for dx <- 0..map_size(map),
          dy <- 0..map_size(map),
          dx != 0 or dy != 0,
          Map.has_key?(map, {dx, dy}),
          do: {dx, dy}

    res =
      Enum.flat_map(directions, fn direction ->
        find_antenna_in_direction(map, start_antenna, direction)
      end)

    elapsed = System.monotonic_time(:microsecond) - start
    IO.puts("Finished in #{elapsed / 1000}ms")

    res
  end

  defp find_antenna_in_direction(map, start_antenna, {dx, dy}) do
    Stream.iterate(start_antenna.pos, fn {x, y} -> {x + dx, y + dy} end)
    # Skip the starting position
    |> Stream.drop(1)
    |> Stream.take_while(&Map.has_key?(map, &1))
    |> Enum.find_value([], fn pos ->
      tile = Map.get(map, pos)

      if tile.is_antenna and tile.frequency == start_antenna.frequency do
        [tile]
      end
    end)
  end
end
