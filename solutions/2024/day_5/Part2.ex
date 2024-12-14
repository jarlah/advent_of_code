defmodule AOC2024.Day5.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day5.Part2.Solution.solution(AOC2024.Day5.Input.parsed_test_input())
      123
      iex> AOC2024.Day5.Part2.Solution.solution(AOC2024.Day5.Input.parsed_input(AOC2024.Day5.Input.input()))
      6142

  """
  def solution({raw_rules, raw_updates}) do
    rules =
      raw_rules
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(fn [n1, n2] -> {String.to_integer(n1), String.to_integer(n2)} end)

    raw_updates
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
    |> Enum.filter(&(not is_valid_update(&1, rules)))
    |> Enum.map(&fix_invalid_update(&1, rules))
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

  defp fix_invalid_update(update, rules, passes \\ 1) do
    new_update =
      update
      |> Enum.reduce(update, fn next, acc ->
        rules
        |> Enum.filter(&(&1 |> Tuple.to_list() |> hd() == next))
        |> Enum.reduce(acc, fn {_, b}, acc_ ->
          b_index = acc_ |> Enum.find_index(&(&1 == b))
          new_next_id = acc_ |> Enum.find_index(&(&1 == next))

          if b_index < new_next_id,
            do: acc_ |> List.replace_at(new_next_id, b) |> List.replace_at(b_index, next),
            else: acc_
        end)
      end)

    if is_valid_update(new_update, rules) do
      # IO.inspect("Used #{passes} passes to fix update")
      new_update
    else
      fix_invalid_update(new_update, rules, passes + 1)
    end
  end
end
