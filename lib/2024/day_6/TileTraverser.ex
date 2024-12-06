defmodule AOC2024.Day6.TileTraverser do
  alias AOC2024.Day6.Tile

  @spec traverse_map(list(Tile.t()), AOC2024.Day6.Tile.t(), integer()) ::
          {:ok, list(Tile.t())} | {:cycling, list(Tile.t())}
  def traverse_map(map, guard, traversals \\ 0)
  def traverse_map(map, _guard, traversals) when traversals > length(map), do: {:cycling, map}

  def traverse_map(map, %Tile{x: guard_x, y: guard_y, direction: direction} = guard, traversals)
      when is_list(map) and is_atom(direction) do
    guard_index = map |> find_index_by_coord(guard_x, guard_y)
    new_guard = Tile.move(guard)
    new_guard_idx = map |> find_index_by_coord(new_guard.x, new_guard.y)

    if new_guard_idx && new_guard.y < length(map) && new_guard.y >= 0 do
      is_obstruction = Tile.is_obstruction(Enum.at(map, new_guard_idx))
      is_obstacle = Tile.is_obstacle(Enum.at(map, new_guard_idx))

      if is_obstacle || is_obstruction do
        guard = Tile.turn(guard)

        traverse_map(
          cross_out(map, guard_index),
          Tile.move(guard),
          traversals + 1
        )
      else
        traverse_map(cross_out(map, guard_index), new_guard, traversals + 1)
      end
    else
      {:ok, cross_out(map, guard_index)}
    end
  end

  defp cross_out(map, index) do
    tile = Enum.at(map, index)
    map |> List.replace_at(index, Tile.visit(tile))
  end

  defp find_index_by_coord(map, target_x, target_y),
    do: map |> Enum.find_index(fn %Tile{x: x, y: y} -> x == target_x && y == target_y end)
end
