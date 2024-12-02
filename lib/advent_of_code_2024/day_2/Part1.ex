defmodule AdventOfCode2024.Day2.Part1.Solution do
  import AdventOfCode2024.Day2.Input, only: [parsed_input: 0]

  def solution do
    parsed_input()
    |> Enum.map(&validate_report/1)
    |> Enum.count(fn
      {:safe, _} -> true
      _ -> false
    end)
  end

  defp validate_report(level) when is_list(level) do
    cond do
      is_valid_level(level, fn (diff) -> diff >= 1 and diff <= 3 end) ->
        {:safe, level}
      is_valid_level(level, fn (diff) -> diff <= -1 and diff >= -3 end) ->
        {:safe, level}
      true ->
        {:unsafe, level}
    end
  end

  defp validate_report(level), do: {:unsafe, level}

  defp is_valid_level(level, valid) do
    level
    |> Stream.with_index()
    |> Enum.take_while(fn {item, index} ->
      next_item = Enum.at(level, index + 1)

      if next_item do
        valid.(item - next_item)
      else
        true
      end
    end)
    |> length() == length(level)
  end
end
