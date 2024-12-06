defmodule AOC2024.Day6.Tile do
  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          c: char(),
          obstacle: boolean(),
          guard: boolean()
        }

  defstruct x: -1, y: -1, c: "", obstacle: false, guard: false
end
