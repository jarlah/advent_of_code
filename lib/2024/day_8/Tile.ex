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

  def set_antinode(%__MODULE__{} = tile, frequency),
    do: %__MODULE__{tile | is_antinode: true, antinode_frequency: frequency}

  def set_neighbour(%__MODULE__{neighbours: neighbours} = tile, new_neighbour),
    do: %__MODULE__{tile | neighbours: Map.put(neighbours, new_neighbour.pos, new_neighbour)}

  def distance_between(%__MODULE__{pos: pos_tile1}, %__MODULE__{pos: pos_tile2}) do
    {x1, y1} = pos_tile1
    {x2, y2} = pos_tile2
    {x2 - x1, y2 - y1}
  end

  def to_string(%__MODULE__{
        frequency: frequency,
        is_antenna: is_antenna,
        is_antinode: is_antinode
      }) do
    cond do
      is_antinode -> "##{frequency}"
      is_antenna -> "T#{frequency}"
      true -> ".#{frequency}"
    end
  end
end
