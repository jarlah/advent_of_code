defmodule AOC2024.Day8.Tile do
  @type t() :: %__MODULE__{
          pos: {integer(), integer()},
          neighbours: %{optional({integer(), integer()}) => t()},
          frequency: String.t(),
          is_antenna: boolean(),
          is_antinode: boolean(),
          antinode_frequency: char()
        }

  defstruct pos: nil,
            neighbours: %{},
            frequency: nil,
            is_antenna: false,
            is_antinode: false,
            antinode_frequency: nil

  def new_antenna(pos, frequency) when is_tuple(pos),
    do: %__MODULE__{pos: pos, frequency: frequency, is_antenna: true}

  def new_empty(pos) when is_tuple(pos),
    do: %__MODULE__{pos: pos}

  def set_antinode(%__MODULE__{is_antinode: is_antinode} = tile, frequency) when not is_antinode,
    do: %__MODULE__{tile | is_antinode: true, antinode_frequency: frequency}

  def set_neighbour(%__MODULE__{neighbours: neighbours} = tile, new_neighbour),
    do: %__MODULE__{tile | neighbours: Map.put(neighbours, new_neighbour.pos, new_neighbour)}

  def to_string(%__MODULE__{
        is_antenna: is_antenna,
        is_antinode: is_antinode,
        neighbours: neighbours
      }) do
    cond do
      is_antenna and Map.keys(neighbours) |> length() > 0 -> "@"
      is_antenna -> "T"
      is_antinode -> "#"
      true -> "."
    end
  end
end
