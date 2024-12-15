defmodule AOC2024.Day3.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day3.Part1.Solution.solution(AOC2024.Day3.Input.test_input())
      161

  """
  def solution(input) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, input)
    |> Enum.map(&(get_int_at(&1, 1) * get_int_at(&1, 2)))
    |> Enum.sum()
  end

  defp get_int_at(str, i) do
    str |> Enum.at(i) |> String.to_integer()
  end
end
