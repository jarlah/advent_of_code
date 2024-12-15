defmodule AOC2024.Day4.Input do
  def parsed_input do
    File.open!(Path.join(__DIR__, "input.txt"), [:read, :utf8])
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
  end

  def test_string,
    do: """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    """

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day4.Input.reverse_test_string()

  """
  def reverse_test_string,
    do:
      horizontal_input()
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.map(&List.to_string/1)

  @doc ~S"""
  ## Examples

      iex> ["MMMSXXMASM" | _tail ] = AOC2024.Day4.Input.horizontal_input()

  """
  def horizontal_input do
    test_string()
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
  end
end
