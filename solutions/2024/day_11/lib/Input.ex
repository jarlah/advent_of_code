defmodule AOC2024.Day11.Input do
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
  end

  def test_input, do: "125 17"
end
