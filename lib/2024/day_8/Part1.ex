defmodule AOC2024.Day8.Part1.Solution do
  alias AOC2024.Day8.Tile
  alias AOC2024.Day8.TileParser
  alias AOC2024.Day8.TileFormatter

  @doc ~S"""
  ## Examples
      iex> AOC2024.Day8.Tile.distance_between(%AOC2024.Day8.Tile{pos: {1,5}}, %AOC2024.Day8.Tile{pos: {7, 3}})
      {6, -2}
      iex> AOC2024.Day8.Tile.distance_between(%AOC2024.Day8.Tile{pos: {6,5}}, %AOC2024.Day8.Tile{pos: {2, 3}})
      {-4, -2}
      iex> AOC2024.Day8.Part1.Solution.solution(AOC2024.Day8.Input.test_input())
      14

  """
  def solution(input) do
    width = input |> hd() |> String.to_charlist() |> length()
    height = input |> length()

    map =
      input
      |> TileParser.parse()

    directions =
      for dx <- -width..width,
          dy <- -height..height,
          dx != 0 or dy != 0,
          Map.has_key?(map, {dx, dy}),
          do: {dx, dy}

    map
    |> tap(&TileFormatter.print_grid(&1, width))
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
        %Tile{pos: {t_x, t_y}} = tile = tile |> Tile.set_neighbour(neighbour)
        neighbour = neighbour |> Tile.set_neighbour(tile)

        acc = acc |> Map.replace(neighbour.pos, neighbour) |> Map.replace(tile.pos, tile)

        {x, y} = Tile.distance_between(tile, neighbour) |> IO.inspect()
        antinode_after = {t_x + 2 * x, t_y + 2 * y}
        antinode_behind = {t_x - x, t_y - y}

        acc =
          if Map.has_key?(acc, antinode_after) do
            Map.update!(acc, antinode_after, fn tile ->
              Tile.set_antinode(tile, neighbour.frequency)
            end)
          else
            acc
          end

        acc =
          if Map.has_key?(acc, antinode_behind) do
            Map.update!(acc, antinode_behind, fn tile ->
              Tile.set_antinode(tile, neighbour.frequency)
            end)
          else
            acc
          end

        acc
      end)
    end)
    |> tap(&TileFormatter.print_grid(&1, width))
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
end
