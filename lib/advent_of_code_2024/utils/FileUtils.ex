defmodule AdventOfCode2024.Utils.FileUtils do
  def read_numbers do
    File.read!("inputs/day1")
    |> then(fn line ->
      line
      |> String.split("\r\n")
    end)
    |> Enum.map(fn line ->
      line
      |> String.split(~r"\s+")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
  end
end
