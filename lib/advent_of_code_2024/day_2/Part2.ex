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
    {:unsafe, report}
  end
end
