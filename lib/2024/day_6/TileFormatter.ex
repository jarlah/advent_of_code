defmodule AOC2024.Day6.TileFormatter do
  alias AOC2024.Day6.Tile

  @spec print_grid(list(Tile.t()), pos_integer()) :: :ok
  def print_grid(tiles, width) do
    chars = Enum.map(tiles, &Tile.to_string(&1))
    max_len = chars |> Enum.map(&String.length/1) |> Enum.max()

    horizontal_line = build_horizontal_line(width, max_len)

    tiles
    |> Enum.chunk_every(width)
    |> Enum.each(fn row ->
      IO.puts(horizontal_line)

      row_str =
        row
        |> Enum.map(&pad_cell(Tile.to_string(&1), max_len))
        |> Enum.join("|")

      IO.puts("|" <> row_str <> "|")
    end)

    IO.puts(horizontal_line)
  end

  defp build_horizontal_line(width, max_len) do
    cell_width = max_len + 2

    ("+" <> String.duplicate("-", cell_width))
    |> String.duplicate(width)
    |> Kernel.<>("+")
  end

  defp pad_cell(content, max_len) do
    " " <> String.pad_trailing(content, max_len) <> " "
  end
end
