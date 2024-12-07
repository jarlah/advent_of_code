defmodule AOC2024.Day7.OperatorPermutations do
  @operators [&+/2, &-/2, &*/2, &//2]

  def solve(numbers) do
    operator_permutations = permutations(@operators, length(numbers) - 1)

    Stream.map(operator_permutations, fn ops ->
      numbers
      # add nil for the last number, for ex [10, 19] and [+] will be zipped as [10, 19] and [+, nil]
      |> Enum.zip(ops ++ [nil])
      |> Enum.flat_map(fn
        {num, nil} -> [num]
        {num, op} -> [num, op]
      end)
      |> solve_equation()
    end)
  end

  defp permutations(_, 0), do: [[]]

  defp permutations(list, k) do
    for head <- list, tail <- permutations(list, k - 1), do: [head | tail]
  end

  defp solve_equation(equation, acc \\ 0)
  defp solve_equation([], acc), do: acc

  defp solve_equation([num1, op, num2 | tail], acc) when is_function(op) do
    solve_equation(tail, acc + op.(num1, num2))
  end

  defp solve_equation([op, num2 | tail], acc) when is_function(op) do
    solve_equation(tail, op.(acc, num2))
  end
end
