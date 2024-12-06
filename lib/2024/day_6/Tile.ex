defmodule AOC2024.Day6.Tile do
  @type direction :: :up | :down | :right | :left

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          is_obstacle: boolean(),
          is_obstruction: boolean(),
          is_guard: boolean(),
          direction: direction(),
          visited: boolean(),
          visited_times: integer()
        }

  defstruct x: nil,
            y: nil,
            is_obstacle: false,
            is_obstruction: false,
            is_guard: false,
            direction: nil,
            visited: false,
            visited_times: 0

  @spec is_guard(AOC2024.Day6.Tile.t()) :: boolean()
  def is_guard(%__MODULE__{is_guard: is_guard}),
    do: is_guard

  @spec is_obstacle(AOC2024.Day6.Tile.t()) :: boolean()
  def is_obstacle(%__MODULE__{is_obstacle: is_obstacle}),
    do: is_obstacle

  @spec is_obstruction(AOC2024.Day6.Tile.t()) :: boolean()
  def is_obstruction(%__MODULE__{is_obstruction: is_obstruction}),
    do: is_obstruction

  @spec move(AOC2024.Day6.Tile.t()) :: AOC2024.Day6.Tile.t()
  def move(%__MODULE__{x: x, y: y, direction: :up} = tile),
    do: %__MODULE__{tile | x: x, y: y - 1}

  def move(%__MODULE__{x: x, y: y, direction: :down} = tile),
    do: %__MODULE__{tile | x: x, y: y + 1}

  def move(%__MODULE__{x: x, y: y, direction: :right} = tile),
    do: %__MODULE__{tile | x: x + 1, y: y}

  def move(%__MODULE__{x: x, y: y, direction: :left} = tile),
    do: %__MODULE__{tile | x: x - 1, y: y}

  @spec turn(AOC2024.Day6.Tile.t()) :: AOC2024.Day6.Tile.t()
  def turn(%__MODULE__{direction: :up} = tile),
    do: %__MODULE__{tile | direction: :right}

  def turn(%__MODULE__{direction: :right} = tile),
    do: %__MODULE__{tile | direction: :down}

  def turn(%__MODULE__{direction: :down} = tile),
    do: %__MODULE__{tile | direction: :left}

  def turn(%__MODULE__{direction: :left} = tile),
    do: %__MODULE__{tile | direction: :up}

  @spec visit(AOC2024.Day6.Tile.t()) :: AOC2024.Day6.Tile.t()
  def visit(%__MODULE__{} = tile),
    do: %__MODULE__{tile | visited: true, visited_times: tile.visited_times + 1}

  @spec to_string(AOC2024.Day6.Tile.t()) :: String.t()
  def to_string(%__MODULE__{
        is_guard: is_guard,
        is_obstruction: is_obstruction,
        is_obstacle: is_obstacle,
        direction: direction,
        visited: visited
      }) do
    cond do
      visited ->
        "X"

      is_guard ->
        case direction do
          :up -> "^"
          :down -> "v"
          :right -> ">"
          :left -> "<"
        end

      is_obstacle ->
        "#"

      is_obstruction ->
        "O"

      true ->
        "."
    end
  end
end
