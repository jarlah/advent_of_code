defmodule AdventOfCode2024.Day3.Part2.Solution do
  import AdventOfCode2024.Day3.Input

  def solution do
    input()
    |> String.to_charlist()
    |> List.foldl({:enabled, "", 0}, fn
      char, {:disabled, str, sum} ->
        cond do
          String.match?(str, ~r/.*do\(\)$/) ->
            {:enabled, "#{<<char>>}", sum}
          true ->
            {:disabled, "#{str}#{<<char>>}", sum}
        end
      char, {:enabled, str, sum} ->
        cond do
          String.match?(str, ~r/.*don't\(\)$/) ->
            {:disabled, "#{str}#{<<char>>}", sum}
          String.match?(str, ~r/.*mul\((\d{1,3}),(\d{1,3})\)/) ->
            mulSum = Regex.scan(~r/.*mul\((\d{1,3}),(\d{1,3})\)/, str)
            |> Enum.map(&(get_int_at(&1, 1) * get_int_at(&1, 2)))
            |> List.first()
            {:enabled, "#{<<char>>}", mulSum + sum}
          true ->
            {:enabled, "#{str}#{<<char>>}", sum}
        end
    end)
  end

  defp get_int_at(str, i) do
    str |> Enum.at(i) |> String.to_integer()
  end
end
