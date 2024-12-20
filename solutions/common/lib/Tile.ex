defmodule Tile do
  @type type :: :robot | :box | :obstacle
  @type t() :: %__MODULE__{
          id: any(),
          x: integer(),
          y: integer(),
          width: integer(),
          height: integer(),
          type: type(),
          display: String.t()
        }

  defstruct id: nil,
            x: nil,
            y: nil,
            width: 1,
            height: 1,
            type: nil,
            display: nil

  def move(%__MODULE__{x: x, y: y} = tile, dx, dy) do
    %__MODULE__{tile | x: x + dx, y: y + dy}
  end

  def print_tile_map(map, options \\ []) do
    case Keyword.get(options, :layout, :simple) do
      :simple -> print_simple_tile_map(map, options)
      :advanced -> print_advanced_tile_map(map, options)
    end
  end

  defp print_simple_tile_map(map, options) do
    default_tile = Keyword.get(options, :default_tile, ".")

    rows = Enum.max_by(map, & &1.y).y + 1
    cols = Enum.max_by(map, & &1.x).x + 1

    grid =
      for y <- 0..(rows - 1), into: [] do
        for x <- 0..(cols - 1), into: [] do
          case Enum.find(map, fn tile -> tile.x == x and tile.y == y end) do
            %Tile{display: display} -> display
            _ -> default_tile
          end
        end
      end

    grid
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.each(&IO.puts/1)

    map
  end

  defp print_advanced_tile_map(map, options) do
    default_tile = Keyword.get(options, :default_tile, ".")

    max_x = Enum.max_by(map, fn tile -> tile.x + tile.width - 1 end)
    max_y = Enum.max_by(map, fn tile -> tile.y + tile.height - 1 end)

    rows = max_y.y + max_y.height
    cols = max_x.x + max_x.width

    grid =
      for y <- 0..(rows - 1) do
        for x <- 0..(cols - 1) do
          tile = Enum.find(map, fn t ->
            x >= t.x and x < t.x + t.width and
            y >= t.y and y < t.y + t.height
          end)

          case tile do
            %Tile{display: display, width: w, height: h} ->
              if x >= tile.x and x < tile.x + w and y >= tile.y and y < tile.y + h do
                display
              else
                default_tile
              end
            _ -> default_tile
          end
        end
      end

    grid
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.each(&IO.puts/1)

    map
  end

  @spec parse_map(list(String.t())) :: map()
  def parse_map(input) do
    input
    |> Enum.take_while(&String.starts_with?(&1, "#"))
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, y}, acc ->
      columns =
        line
        |> String.to_charlist()
        |> Enum.map(&<<&1>>)
        |> Enum.with_index()
        |> Enum.map(fn {tile, x} ->
          %Tile{x: x, y: y, type: :default, display: tile}
        end)

      columns ++ acc
    end)
    |> Enum.reverse()
    |> Enum.map(fn tile -> {{tile.x, tile.y}, tile} end)
    |> Enum.into(%{})
  end
end
