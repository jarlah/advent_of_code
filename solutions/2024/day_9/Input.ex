defmodule AOC2024.Day9.Input do
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
  end

  def test_input, do: "2333133121414131402"
end
