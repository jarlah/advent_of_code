defmodule AOC2024.Day8.Part1.Solution do
  alias AOC2024.Day8.Tile
  alias AOC2024.Day8.TileParser
  # alias AOC2024.Day8.TileFormatter

  @doc ~S"""
  ## Examples
      iex> AOC2024.Day8.Tile.distance_between(%AOC2024.Day8.Tile{pos: {1,5}}, %AOC2024.Day8.Tile{pos: {7, 3}})
      {6, -2}
      iex> AOC2024.Day8.Tile.distance_between(%AOC2024.Day8.Tile{pos: {6,5}}, %AOC2024.Day8.Tile{pos: {2, 3}})
      {-4, -2}
      iex> AOC2024.Day8.Part1.Solution.solution(AOC2024.Day8.Input.test_input())
      14
      iex> AOC2024.Day8.Part1.Solution.solution(AOC2024.Day8.Input.input())
      252

  """
  def solution(input, resonant_harmonics \\ false) do
    width = input |> hd() |> String.to_charlist() |> length()
    height = input |> length()

    map =
      input
      |> TileParser.parse()

    directions =
      for dx <- -width..width,
          dy <- -height..height,
          dx != 0 or dy != 0,
          do: {dx, dy}

    map
    # |> tap(&TileFormatter.print_grid(&1, width))
    |> Map.filter(fn {_, value} -> value.is_antenna end)
    |> Map.keys()
    |> Enum.reduce(map, fn pos, acc ->
      tile = Map.get(map, pos)

      map
      |> then(
        &Enum.flat_map(directions, fn direction ->
          find_antenna_in_direction(&1, tile, direction)
        end)
      )
      |> Enum.reduce(acc, fn neighbour, acc ->
        {x, y} = distance = Tile.distance_between(tile, neighbour)
        %Tile{pos: {tile_x, tile_y}} = tile

        [
          if(resonant_harmonics,
            do: get_all_antinodes_after(acc, tile, distance),
            else: [
              Map.get(acc, {tile_x + 2 * x, tile_y + 2 * y}),
              Map.get(acc, {tile_x - x, tile_y - y})
            ]
          )
        ]
        |> List.flatten()
        |> Enum.reject(&is_nil/1)
        |> Enum.reduce(acc, fn tile, acc ->
          Map.update!(acc, tile.pos, &Tile.set_antinode(&1, neighbour.frequency))
        end)
        |> Map.update!(neighbour.pos, &Tile.set_neighbour(&1, tile))
        |> Map.update!(tile.pos, &Tile.set_neighbour(&1, neighbour))
      end)
    end)
    # |> tap(&TileFormatter.print_grid(&1, width))
    |> Map.values()
    |> Enum.count(fn tile -> tile.is_antinode end)
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

  defp get_all_antinodes_after(map, start_antenna, {dx, dy}) do
    Stream.iterate(start_antenna.pos, fn {x, y} -> {x + dx, y + dy} end)
    # Skip the starting position
    |> Stream.drop(1)
    |> Stream.take_while(&Map.has_key?(map, &1))
    |> Stream.map(&Map.get(map, &1))
    |> Enum.to_list()
  end
end
