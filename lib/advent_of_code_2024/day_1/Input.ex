defmodule AdventOfCode2024.Day1.Input do
  def parsed_input do
    input_lines()
    |> Enum.map(fn line ->
      line
      |> String.split(~r"\s+")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
  end

  def input_lines do
    File.open!(Path.join(__DIR__, "input.txt"), [:read, :utf8])
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
