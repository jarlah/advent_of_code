defmodule AOC2024.Day7.Input do
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn [result_str, numbers_str] ->
      {
        result_str
        |> String.to_integer(),
        numbers_str
        |> String.trim()
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      }
    end)
    |> Enum.sort_by(fn {_, list} -> length(list) end)
  end

  def test_input do
    [
      {190, [10, 19]},
      {3267, [81, 40, 27]},
      {83, [17, 5]},
      {156, [15, 6]},
      {7290, [6, 8, 6, 15]},
      {161_011, [16, 10, 13]},
      {192, [17, 8, 14]},
      {21037, [9, 7, 18, 13]},
      {292, [11, 6, 16, 20]}
    ]
  end
end
