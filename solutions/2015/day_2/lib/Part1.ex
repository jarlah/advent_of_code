defmodule AOC2015.Day2.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2015.Day2.Part1.Solution.solution(Input.read_file_to_lines!("input.txt"))
      0

  """
  def solution(input) do
    input
    |> Enum.map(&String.split(&1, "x"))
    |> Enum.map(fn [length, width, height] ->
      {String.to_integer(length), String.to_integer(width), String.to_integer(height)}
    end)
    |> Enum.map(&get_area/1)
    |> Enum.sum()
  end

  @spec get_area({number(), number(), number()}) :: number()
  def get_area({length, width, height}) do
    side1 = length * width
    side2 = width * height
    side3 = height * length

    2 * side1 + 2 * side2 + 2 * side3 +
      Enum.min([side1, side2, side3])
  end
end
