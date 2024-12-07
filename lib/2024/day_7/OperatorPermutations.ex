defmodule AOC2024.Day7.OperatorPermutations do
  def solve(numbers, operators, acc, result) do
    operator_permutations = permutations(operators, length(numbers) - 1)

    Stream.map(operator_permutations, fn ops ->
      try do
        numbers
        # add nil for the last number, for ex [10, 19] and [+] will be zipped as [10, 19] and [+, nil]
        |> Enum.zip(ops ++ [nil])
        |> Enum.flat_map(fn
          {num, nil} -> [num]
          {num, op} -> [num, op]
        end)
        |> solve_equation(acc, result)
      rescue
        _ -> acc
      end
    end)
  end

  defp permutations(_, 0), do: [[]]

  defp permutations(list, k) do
    for head <- list, tail <- permutations(list, k - 1), do: [head | tail]
  end

  defp solve_equation([], acc, _result), do: acc

  defp solve_equation([num1, op, num2 | tail], acc, result) when is_function(op) do
    if to_number(acc) > result,
      do: acc,
      else: solve_equation(tail, combine(acc, op.(num1, num2)), result)
  end

  defp solve_equation([op, num2 | tail], acc, result) when is_function(op) do
    if to_number(acc) > result,
      do: acc,
      else: solve_equation(tail, op.(acc, num2), result)
  end

  defp combine(acc, num) when is_binary(acc) and is_binary(num) do
    acc = to_number(acc)
    num = to_number(num)
    "#{acc + num}"
  end

  defp combine(acc, num), do: acc + num

  defp to_number(str) when is_number(str), do: str

  defp to_number(str),
    do:
      if(String.contains?(str, "."),
        do: AOC2024.Day7.Input.parse_float!(str),
        else: String.to_integer(str)
      )
end
