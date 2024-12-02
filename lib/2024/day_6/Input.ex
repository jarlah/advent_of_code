defmodule AOC2024.Day6.Input do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Input.input()

  """
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  def test_input do
    [
      "....#.....",
      ".........#",
      "..........",
      "..#.......",
      ".......#..",
      "..........",
      ".#..^.....",
      "........#.",
      "#.........",
      "......#..."
    ]
  end

  def test_obstacle_input do
    [
      "....#.....",
      ".........#",
      "..........",
      "..#.......",
      ".......#..",
      "..........",
      ".#..^.....",
      "........#.",
      "#..O......",
      "......#..."
    ]
  end
end
