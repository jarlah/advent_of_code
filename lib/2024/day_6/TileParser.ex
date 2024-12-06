defmodule AOC2024.Day6.TileParser do
  alias AOC2024.Day6.Tile

  @spec parse(list(String.t())) :: list(Tile.t())
  def parse(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn {col, x} ->
        %Tile{
          x: x,
          y: y,
          is_obstacle: <<col>> == "#",
          is_guard: <<col>> == "^",
          is_obstruction: <<col>> == "O",
          direction: :up
        }
      end)
    end)
    |> List.flatten()
  end
end
