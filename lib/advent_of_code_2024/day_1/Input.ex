defmodule AdventOfCode2024.Day1.Input do
  def parsed_input do
    input_lines()
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
  end

  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> AdventOfCode2024.Day1.Input.test_input()
      [
        [3, 4, 2, 1, 3, 3],
        [4, 3, 5, 3, 9, 3]
      ]

  """
  def test_input do
    [
      [3, 4, 2, 1, 3, 3],
      [4, 3, 5, 3, 9, 3]
    ]
  end

  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> [ "80784   47731", "81682   36089" | _tail] = AdventOfCode2024.Day1.Input.input_lines()

  """
  def input_lines do
    File.open!(Path.join(__DIR__, "input.txt"), [:read, :utf8])
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
