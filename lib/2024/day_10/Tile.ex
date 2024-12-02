defmodule AOC2024.Day10.Tile do
  defstruct pos: nil,
            number: nil,
            is_trail_head: nil,
            score: nil

  def possible_moves(%__MODULE__{pos: {x, y}}) do
    [
      # Move left
      {x - 1, y},
      # Move right
      {x + 1, y},
      # Move up
      {x, y - 1},
      # Move down
      {x, y + 1}
    ]
  end
end
