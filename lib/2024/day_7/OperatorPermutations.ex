defmodule AOC2024.Day7.OperatorPermutations do
  def solve(wanted_result, numbers, operators) do
    operators
    |> permutations(length(numbers) - 1)
    |> Enum.find_value(0, &try_solve_equation(&1, numbers, wanted_result))
  end

  defp try_solve_equation(ops, numbers, wanted_result) do
    equation = build_equation(numbers, ops)

    try do
      case solve_equation(equation, wanted_result) do
        ^wanted_result -> wanted_result
        _ -> false
      end
    rescue
      _ -> false
    end
  end

  defp build_equation(numbers, ops) do
    numbers
    |> Enum.zip(ops ++ [nil])
    |> Enum.flat_map(fn
      {num, nil} -> [num]
      {num, op} -> [num, op]
    end)
  end

  defp permutations(_, 0), do: [[]]

  defp permutations(list, k) do
    for head <- list, tail <- permutations(list, k - 1), do: [head | tail]
  end

  defp solve_equation(_list, _max, acc \\ 0)
  defp solve_equation([], _max, acc), do: acc
  defp solve_equation(_, max, acc) when acc > max, do: acc

  defp solve_equation([num1, op, num2 | tail], max, acc) when is_function(op) do
    solve_equation(tail, max, acc + op.(num1, num2))
  end

  defp solve_equation([op, num2 | tail], max, acc) when is_function(op) do
    solve_equation(tail, max, op.(acc, num2))
  end
end
