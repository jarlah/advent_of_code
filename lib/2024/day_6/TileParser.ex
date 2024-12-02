defmodule AOC2024.Day6.TileParser do
  alias AOC2024.Day6.Tile

  @spec parse(list(String.t())) :: %{optional({integer(), integer()}) => Tile.t()}
  def parse(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn {col, x} ->
        cond do
          <<col>> == "#" -> Tile.new_obstacle({x, y})
          <<col>> == "^" -> Tile.new_guard({x, y})
          true -> Tile.new_empty({x, y})
        end
      end)
    end)
    |> List.flatten()
    |> Enum.map(fn tile ->
      {
        tile.pos,
        tile
      }
    end)
    |> Enum.into(%{})
  end
end
