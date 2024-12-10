defmodule AOC2024.Day9.Part1.Solution do
  @doc ~S"""
  ## Examples

      This was one was easy and i solved it myself. Got some help on elixir forum on the algo itself, but it was minor help.

      iex> AOC2024.Day9.Part1.Solution.read_disk_layout("12345") |> Enum.join("")
      "0..111....22222"
      iex> AOC2024.Day9.Part1.Solution.read_disk_layout("90909") |> Enum.join("")
      "000000000111111111222222222"
      iex> AOC2024.Day9.Part1.Solution.read_disk_layout(AOC2024.Day9.Input.test_input()) |> Enum.join("")
      "00...111...2...333.44.5555.6666.777.888899"
      iex> AOC2024.Day9.Part1.Solution.read_disk_layout(AOC2024.Day9.Input.input())
      iex> AOC2024.Day9.Part1.Solution.solution(AOC2024.Day9.Input.test_input())
      1928
      iex> AOC2024.Day9.Part1.Solution.solution(AOC2024.Day9.Input.input())
      6283170117911

  """
  def solution(input) do
    input
    |> read_disk_layout()
    |> start_defragmentation()
    |> Enum.with_index()
    |> Enum.reduce(0, fn
      {n, i}, acc when n != "." -> acc + i * String.to_integer(n)
      _, acc -> acc
    end)
  end

  @spec read_disk_layout(binary()) :: list()
  def read_disk_layout(input) do
    input
    |> String.to_charlist()
    |> Enum.map(&String.to_integer(<<&1>>))
    |> parse_raw_format()
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

  defp start_defragmentation(list) do
    defragment(list, [])
  end

  defp defragment([], acc), do: Enum.reverse(acc)

  defp defragment([head | tail], acc) do
    {replaced, tail} = process_item(head, tail)
    new_acc = [replaced | acc]
    defragment(tail, new_acc)
  end

  defp process_item(char, []), do: {char, []}

  defp process_item(".", tail) do
    last_idx = tail |> Enum.reverse() |> Enum.find_index(&(&1 != "."))

    if last_idx == nil do
      {".", tail}
    else
      last_idx = (tail |> tl() |> length()) - last_idx
      {last_char, _} = List.pop_at(tail, last_idx)
      {last_char, List.update_at(tail, last_idx, fn _ -> "." end)}
    end
  end

  defp process_item(char, tail) do
    {char, tail}
  end
end
