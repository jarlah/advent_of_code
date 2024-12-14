defmodule AOC2024.Day12.Input do
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  def test_input do
    [
      "RRRRIICCFF",
      "RRRRIICCCF",
      "VVRRRCCFFF",
      "VVRCCCJFFF",
      "VVVVCJJCFE",
      "VVIVCCJJEE",
      "VVIIICJJEE",
      "MIIIIIJJEE",
      "MIIISIJEEE",
      "MMMISSJEEE"
    ]
  end

  def test_input_1 do
    [
      "AAAA",
      "BBCD",
      "BBCC",
      "EEEC"
    ]
  end

  def test_input_2 do
    [
      "OOOOO",
      "OXOXO",
      "OOOOO",
      "OXOXO",
      "OOOOO"
    ]
  end
end
