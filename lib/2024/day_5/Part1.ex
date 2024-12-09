defmodule AOC2024.Day5.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day5.Part1.Solution.solution(AOC2024.Day5.Input.parsed_test_input())
      143
      iex> AOC2024.Day5.Part1.Solution.solution(AOC2024.Day5.Input.parsed_input(AOC2024.Day5.Input.input()))
      5391

  """
  def solution({raw_rules, raw_updates}) do
    rules =
      raw_rules
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(fn [n1, n2] -> {String.to_integer(n1), String.to_integer(n2)} end)

    raw_updates
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
    |> Enum.filter(&is_valid_update(&1, rules))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  defp is_valid_update(update, rules) do
    update
    |> Enum.with_index()
    |> Enum.reduce_while(nil, fn {n, idx}, _ ->
      rules_to_match =
        rules |> Enum.filter(fn {x, _} -> x == n end)

      all_valid_rules =
        rules_to_match
        |> Enum.filter(fn {_, y} -> Enum.find_index(update, fn u -> u == y end) > idx end)
        |> length() == length(rules_to_match)

      if all_valid_rules,
        do: {:cont, true},
        else: {:halt, false}
    end)
  end
end
