defmodule AOC2015.Day1.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2015.Day1.Part1.Solution.solution("(())")
      0
      iex> AOC2015.Day1.Part1.Solution.solution("()()")
      0
      iex> AOC2015.Day1.Part1.Solution.solution("(((")
      3
      iex> AOC2015.Day1.Part1.Solution.solution("(()(()(")
      3
      iex> AOC2015.Day1.Part1.Solution.solution("))(((((")
      3
      iex> AOC2015.Day1.Part1.Solution.solution("())")
      -1
      iex> AOC2015.Day1.Part1.Solution.solution("))(")
      -1
      iex> AOC2015.Day1.Part1.Solution.solution(")))")
      -3
      iex> AOC2015.Day1.Part1.Solution.solution(")())())")
      -3
      iex> AOC2015.Day1.Part1.Solution.solution(AOC2015.Day1.Input.input())
      138

  """
  def solution(input) do
    Enum.reduce(input |> String.to_charlist() |> Enum.map(&<<&1>>), 0, fn paren, acc ->
      case paren do
        "(" -> acc + 1
        ")" -> acc - 1
      end
    end)
  end
end
