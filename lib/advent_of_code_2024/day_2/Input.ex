defmodule AdventOfCode2024.Day2.Input do
  def parsed_input do
    input()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def fake do
    """
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
    """
  end

  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
  end
end
