defmodule AOC2024.Day7.Part1.Solution do
  import AOC2024.Day7.OperatorPermutations

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day7.Part1.Solution.solution(AOC2024.Day7.Input.input(), AOC2024.Day7.OperatorPermutations.normal_operators)
      945512582195
      iex> AOC2024.Day7.Part1.Solution.solution(AOC2024.Day7.Input.test_input(), AOC2024.Day7.OperatorPermutations.normal_operators)
      3749
  """
  def solution(input, operators, part \\ "1") do
    input
    |> Enum.with_index(1)
    |> Enum.reduce(0, &solve_and_accumulate(&1, &2, operators, part))
  end

  defp solve_and_accumulate({{wanted_result, numbers}, problem_number}, acc, operators, part) do
    IO.puts("Day7.Part#{part}: Solving problem ##{problem_number}")

    case solve(wanted_result, numbers, operators) do
      0 -> acc
      result -> acc + result
    end
  end
end
