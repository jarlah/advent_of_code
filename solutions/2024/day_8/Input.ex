defmodule AOC2024.Day8.Input do
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  def test_input do
    [
      "............",
      "........0...",
      ".....0......",
      ".......0....",
      "....0.......",
      "......A.....",
      "............",
      "............",
      "........A...",
      ".........A..",
      "............",
      "............"
    ]
  end
end
