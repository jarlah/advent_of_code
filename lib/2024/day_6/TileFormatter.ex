defmodule AOC2024.Day6.TileFormatter do
  alias AOC2024.Day6.Tile

  @spec print_grid(%{optional({integer(), integer()}) => Tile.t()}, pos_integer()) :: :ok
  def print_grid(map, width) do
    max_y = map |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    max_len =
      map
      |> Map.values()
      |> Enum.map(&Tile.to_string/1)
      |> Enum.map(&String.length/1)
      |> Enum.max()

    horizontal_line = build_horizontal_line(width, max_len)

    for y <- 0..max_y do
      IO.puts(horizontal_line)
      row_str = build_row_string(map, y, width, max_len)
      IO.puts("|" <> row_str <> "|")
    end

    IO.puts(horizontal_line)
  end

  defp build_horizontal_line(width, max_len) do
    cell_width = max_len + 2

    ("+" <> String.duplicate("-", cell_width))
    |> String.duplicate(width)
    |> Kernel.<>("+")
  end

  defp build_row_string(map, y, width, max_len) do
    0..(width - 1)
    |> Enum.map(fn x ->
      tile = Map.get(map, {x, y}, %Tile{pos: {x, y}})
      pad_cell(Tile.to_string(tile), max_len)
    end)
    |> Enum.join("|")
  end

  defp pad_cell(content, max_len) do
    " " <> String.pad_trailing(content, max_len) <> " "
  end
end
