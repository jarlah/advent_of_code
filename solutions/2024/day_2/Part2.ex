defmodule AOC2024.Day2.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day2.Part2.Solution.solution(AOC2024.Day2.Input.test_input())
      4

  """
  def solution(parsed_input) do
    parsed_input
    |> Enum.map(&validate_report/1)
    |> Enum.count(fn
      {:safe, _} -> true
      {:unsafe, report} -> dampen(report)
    end)
  end

  defp validate_report(report) when is_list(report) do
    cond do
      is_acceptable_report(report) ->
        {:safe, report}

      true ->
        {:unsafe, report}
    end
  end

  defp validate_report(report), do: {:unsafe, report}

  defp is_acceptable_report(report) do
    level_validator(report, &(&1 in 1..3)) ||
      level_validator(report, &(&1 in -1..-3//-1))
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

  defp dampen(report, index \\ 0)

  defp dampen(report, index) when length(report) > index do
    valid =
      report
      |> List.delete_at(index)
      |> is_acceptable_report()

    valid ||
      dampen(report, index + 1)
  end

  defp dampen(_, _), do: false
end
