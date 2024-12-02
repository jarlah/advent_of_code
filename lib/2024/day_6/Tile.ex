defmodule AOC2024.Day6.Tile do
  @type direction :: :up | :down | :right | :left

  @type t() :: %__MODULE__{
          pos: {integer(), integer()},
          is_obstacle: boolean(),
          is_guard: boolean(),
          direction: direction(),
          visited: boolean()
        }

  defstruct pos: nil,
            is_obstacle: false,
            is_guard: false,
            direction: nil,
            visited: false

  def new_obstacle(pos) when is_tuple(pos),
    do: %__MODULE__{pos: pos, is_obstacle: true}

  def new_guard(pos) when is_tuple(pos),
    do: %__MODULE__{pos: pos, is_guard: true, direction: :up}

  def new_empty(pos) when is_tuple(pos),
    do: %__MODULE__{pos: pos}

  @spec is_guard(AOC2024.Day6.Tile.t()) :: boolean()
  def is_guard(%__MODULE__{is_guard: is_guard}),
    do: is_guard

  @spec is_obstacle(AOC2024.Day6.Tile.t()) :: boolean()
  def is_obstacle(%__MODULE__{is_obstacle: is_obstacle}),
    do: is_obstacle

  @spec move(AOC2024.Day6.Tile.t()) :: AOC2024.Day6.Tile.t()
  def move(%__MODULE__{pos: {x, y}, direction: :up} = tile),
    do: %__MODULE__{tile | pos: {x, y - 1}}

  def move(%__MODULE__{pos: {x, y}, direction: :down} = tile),
    do: %__MODULE__{tile | pos: {x, y + 1}}

  def move(%__MODULE__{pos: {x, y}, direction: :right} = tile),
    do: %__MODULE__{tile | pos: {x + 1, y}}

  def move(%__MODULE__{pos: {x, y}, direction: :left} = tile),
    do: %__MODULE__{tile | pos: {x - 1, y}}

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
    do: %__MODULE__{tile | visited: true}

  @spec to_string(AOC2024.Day6.Tile.t()) :: String.t()
  def to_string(%__MODULE__{
        is_guard: is_guard,
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

      true ->
        "."
    end
  end
end
