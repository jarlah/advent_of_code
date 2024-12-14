defmodule AOC2024.Day6.TileTraverser do
  alias AOC2024.Day6.Tile

  @spec traverse_map(%{optional({integer(), integer()}) => Tile.t()}, AOC2024.Day6.Tile.t()) :: %{
          optional({integer(), integer()}) => Tile.t()
        }
  def traverse_map(map, guard) do
    next_tile = Map.get(map, Tile.move(guard).pos)

    if next_tile do
      is_obstacle = Tile.is_obstacle(next_tile)

      if is_obstacle do
        traverse_map(map |> visit(guard), guard |> Tile.turn() |> Tile.move())
      else
        traverse_map(map |> visit(guard), guard |> Tile.move())
      end
    else
      map |> visit(guard)
    end
  end

  defp visit(map, tile) do
    Map.replace!(map, tile.pos, Tile.visit(tile))
  end
end
