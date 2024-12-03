defmodule AdventOfCode2024.Day1.Input do
  def parsed_input do
    input()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
      line
      |> String.split(~r"\s+")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
  end

  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
  end
end
