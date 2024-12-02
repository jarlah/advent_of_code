defmodule AOC2024.Day5.Input do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day5.Input.parsed_input(AOC2024.Day5.Input.input())

  """
  def parsed_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.split_while(&(&1 != ""))
    |> Tuple.to_list()
    |> Enum.map(&Enum.reject(&1, fn s -> s == "" end))
    |> List.to_tuple()
  end

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day5.Input.input()

  """
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
  end

  def test_input do
    """
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
    """
  end

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day5.Input.parsed_test_input()

  """
  def parsed_test_input do
    test_input()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.split_while(&(&1 != ""))
    |> Tuple.to_list()
    |> Enum.map(&Enum.reject(&1, fn s -> s == "" end))
    |> List.to_tuple()
  end
end
