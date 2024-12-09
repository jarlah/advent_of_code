defmodule AOC2024.Day9.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day9.Part1.Solution.solution(AOC2024.Day9.Input.test_input())
      "0099811188827773336446555566.............."

  """
  def solution(input) do
    input
    |> read_disk_layout()
    |> defragment_disk()
    |> tap(&IO.puts(Enum.join(&1, "")))
  end

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day9.Part1.Solution.read_disk_layout("12345")
      "0..111....22222"
      iex> AOC2024.Day9.Part1.Solution.read_disk_layout("90909")
      "000000000111111111222222222"
      iex> AOC2024.Day9.Part1.Solution.read_disk_layout(AOC2024.Day9.Input.test_input())
      "00...111...2...333.44.5555.6666.777.888899"
      iex> AOC2024.Day9.Part1.Solution.read_disk_layout(AOC2024.Day9.Input.input())

  """
  def read_disk_layout(input) do
    input
    |> String.to_charlist()
    |> Enum.map(&String.to_integer(<<&1>>))
    |> parse_raw_format()
    |> tap(&IO.puts(Enum.join(&1, "")))
  end

  defp parse_raw_format(list, acc \\ [], block_id \\ 0)
  defp parse_raw_format([], acc, _block_id), do: acc

  defp parse_raw_format([n1, n2 | tail], acc, block_id) do
    parse_raw_format(
      tail,
      acc ++
        Enum.map(1..n1, fn _ -> "#{block_id}" end) ++
        if(n2 > 0, do: Enum.map(1..n2, fn _ -> "." end), else: []),
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

  defp defragment_disk(input, _acc \\ []), do: input
end
