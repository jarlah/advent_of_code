defmodule AOC2024.Day8.Tile do
  @type t() :: %__MODULE__{
          pos: {integer(), integer()},
          is_antenna: boolean(),
          is_antinode: boolean()
        }

  defstruct pos: nil,
            is_antenna: false,
            is_antinode: false

  def new_antenna(pos) when is_tuple(pos),
    do: %__MODULE__{pos: pos, is_antenna: true}

  def new_antinode(pos) when is_tuple(pos),
    do: %__MODULE__{pos: pos, is_antinode: true}

  def new_empty(pos) when is_tuple(pos),
    do: %__MODULE__{pos: pos}

  def to_string(%__MODULE__{is_antenna: is_antenna, is_antinode: is_antinode}) do
    cond do
      is_antenna -> "T"
      is_antinode -> "#"
      true -> "."
    end
  end
end
