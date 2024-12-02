defmodule AOC2024.Day1.Input do
  def parsed_input do
    File.open!(Path.join(__DIR__, "input.txt"), [:read, :utf8])
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
  end

  def test_input do
    [
      [3, 4, 2, 1, 3, 3],
      [4, 3, 5, 3, 9, 3]
    ]
  end
end
