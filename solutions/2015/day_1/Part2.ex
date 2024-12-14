defmodule AOC2015.Day1.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2015.Day1.Part2.Solution.solution(AOC2015.Day1.Input.input())
      {-1, 1771}

  """
  def solution(input) do
    input
    |> String.to_charlist()
    |> Enum.map(&<<&1>>)
    |> Enum.reduce_while({0, 0}, fn paren, {floor, count} ->
      if floor == -1 do
        {:halt, {floor, count}}
      else
        case paren do
          "(" ->
            {:cont, {floor + 1, count + 1}}

          ")" ->
            {:cont, {floor - 1, count + 1}}
        end
      end
    end)
  end
end
