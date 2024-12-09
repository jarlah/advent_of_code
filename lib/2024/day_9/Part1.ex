defmodule AOC2024.Day9.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day9.Part1.Solution.solution("12345")
      "0..111....22222"
      iex> AOC2024.Day9.Part1.Solution.solution("90909")
      "000000000..111111111..222222222"
      iex> AOC2024.Day9.Part1.Solution.solution(AOC2024.Day9.Input.test_input())
      "00...111...2...333.44.5555.6666.777.888899"

  """
  def solution(input) do
    input
    |> String.to_charlist()
    |> Enum.map(&String.to_integer(<<&1>>))
    |> parse_raw_format()
    |> Enum.join("")
    |> tap(&IO.inspect(&1, limit: :infinity))
  end

  defp parse_raw_format(list, acc \\ [], block_id \\ 0)
  defp parse_raw_format([], acc, _block_id), do: acc

  defp parse_raw_format([n1, n2 | tail], acc, block_id) do
    parse_raw_format(
      tail,
      acc ++ Enum.map(1..n1, fn _ -> "#{block_id}" end) ++ Enum.map(1..n2, fn _ -> "." end),
      block_id + 1
    )
  end

  defp parse_raw_format([n1 | tail], acc, block_id) do
    parse_raw_format(
      tail,
      acc ++ Enum.map(1..n1, fn _ -> "#{block_id}" end),
      block_id + 1
    )
  end
end
