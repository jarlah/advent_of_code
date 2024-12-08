defmodule AOC2024.Day7.Part1.Solution do
  import AOC2024.Day7.OperatorPermutations

  @doc ~S"""
  ## Examples

      #iex> AOC2024.Day7.Part1.Solution.solution(AOC2024.Day7.Input.input(), AOC2024.Day7.Input.normal_operators)
      #945512582195

      iex> AOC2024.Day7.Part1.Solution.solution(AOC2024.Day7.Input.test_input(), AOC2024.Day7.Input.normal_operators)
      3749
  """
  def solution(input, operators) do
    input
    |> Enum.with_index()
    |> Enum.reduce(
      0,
      fn {{wanted_result, numbers}, i}, acc ->
        IO.puts("Solving problem ##{i + 1}")
        solved = solve(wanted_result, numbers, operators)

        if solved, do: acc + solved, else: acc
      end
    )
  end
end
