defmodule AdventOfCode2024.Day2.Part2.Solution do
  import AdventOfCode2024.Day2.Input, only: [parsed_input: 0]

  def solution do
    parsed_input()
    |> Enum.map(&validate_report/1)
    |> Enum.count(fn
      {:safe, _} -> true
      _ -> false
    end)
  end

  defp validate_report(report) when is_list(report) do
    recursive_validate_report(report)
  end

  defp recursive_validate_report(report, _index \\ 0) do
    is_acceptable_level(report)
  end

  defp is_acceptable_level(report) do
    cond do
      level_validator(report, fn diff -> diff >= 1 and diff <= 3 end) or
          level_validator(report, fn diff -> diff <= -1 and diff >= -3 end) ->
        true

      true ->
        false
    end
  end

  defp level_validator(report, valid) do
    report
    |> Stream.with_index()
    |> Enum.take_while(fn {level, index} ->
      next_level = Enum.at(report, index + 1)

      if next_level do
        valid.(level - next_level)
      else
        true
      end
    end)
    |> length() == length(report)
  end
end
