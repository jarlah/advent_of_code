defmodule AOC2024.Day6.Tile do
  @type direction :: :up | :down | :right | :left

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          obstacle: boolean(),
          guard: boolean(),
          direction: direction(),
          visited: boolean(),
          visited_times: integer()
        }

  defstruct x: nil,
            y: nil,
            obstacle: false,
            guard: false,
            direction: :up,
            visited: false,
            visited_times: 0

  def is_guard(%__MODULE__{guard: guard}),
    do: guard

  def is_obstacle(%__MODULE__{obstacle: obstacle}),
    do: obstacle

  def move(%__MODULE__{x: x, y: y, direction: :up} = tile),
    do: %__MODULE__{tile | x: x, y: y - 1}

  def move(%__MODULE__{x: x, y: y, direction: :down} = tile),
    do: %__MODULE__{tile | x: x, y: y + 1}

  def move(%__MODULE__{x: x, y: y, direction: :right} = tile),
    do: %__MODULE__{tile | x: x + 1, y: y}

  def move(%__MODULE__{x: x, y: y, direction: :left} = tile),
    do: %__MODULE__{tile | x: x - 1, y: y}

  def turn(%__MODULE__{direction: :up} = tile),
    do: %__MODULE__{tile | direction: :right}

  def turn(%__MODULE__{direction: :right} = tile),
    do: %__MODULE__{tile | direction: :down}

  def turn(%__MODULE__{direction: :down} = tile),
    do: %__MODULE__{tile | direction: :left}

  def turn(%__MODULE__{direction: :left} = tile),
    do: %__MODULE__{tile | direction: :up}

  def visit(%__MODULE__{} = tile),
    do: %__MODULE__{tile | visited: true, visited_times: tile.visited_times + 1}

  def to_string(%__MODULE__{
        guard: guard,
        obstacle: obstacle,
        direction: direction,
        visited: visited
      }) do
    cond do
      visited ->
        "X"

      guard ->
        case direction do
          :up -> "^"
          :down -> "v"
          :right -> ">"
          :left -> "<"
        end

      obstacle ->
        "#"

      true ->
        "."
    end
  end
end
