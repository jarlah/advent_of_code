defmodule AOC2024.Day8.TileParser do
  import AOC2024.Day8.Utils, only: [is_alphanumeric: 1]
  alias AOC2024.Day8.Tile

  def parse(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {col, x}, acc ->
        position = {x, y}
        tile = parse_tile(col, position)
        Map.put(acc, position, tile)
      end)
    end)
  end

  defp parse_tile(col, position) when is_alphanumeric(col),
    do: Tile.new_antenna(position, <<col>>)

  defp parse_tile(_col, position),
    do: Tile.new_empty(position)
end
