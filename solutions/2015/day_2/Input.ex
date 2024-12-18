defmodule AOC2015.Day2.Input do
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
