defmodule Tile do
  @type type :: :robot | :box | :obstacle
  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          width: integer(),
          height: integer(),
          type: type(),
          display: String.t()
        }

  defstruct x: nil,
            y: nil,
            width: 1,
            height: 1,
            type: nil,
            display: nil

  def move(%__MODULE__{x: x, y: y} = tile, dx, dy) do
    %__MODULE__{tile | x: x + dx, y: y + dy}
  end

  def print_tile_map(map, options \\ []) do
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
end
