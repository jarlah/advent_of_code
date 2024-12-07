defmodule AOC2024.Day7.Input do
  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  def test_input do
    [
      "190: 10 19",
      "3267: 81 40 27",
      "83: 17 5",
      "156: 15 6",
      "7290: 6 8 6 15",
      "161011: 16 10 13",
      "192: 17 8 14",
      "21037: 9 7 18 13",
      "292: 11 6 16 20"
    ]
  end

  def normal_operators, do: [&+/2, &-/2, &*/2, &//2]

  defp double_pipe(left, right) do
    "#{left}#{right}"
  end

  defp divide(left, right) when is_number(left) and is_number(right) do
    "#{left / right}"
  end

  defp divide(left, right) when is_binary(left) and is_binary(right) do
    divide(string_to_number(left), string_to_number(right))
  end

  defp divide(left, right) when is_binary(left) do
    divide(string_to_number(left), right)
  end

  defp divide(left, right) when is_binary(right) do
    divide(left, string_to_number(right))
  end

  defp multiply(left, right) when is_number(left) and is_number(right) do
    "#{left * right}"
  end

  defp multiply(left, right) when is_binary(left) and is_binary(right) do
    multiply(string_to_number(left), string_to_number(right))
  end

  defp multiply(left, right) when is_binary(left) do
    multiply(string_to_number(left), right)
  end

  defp multiply(left, right) when is_binary(right) do
    multiply(left, string_to_number(right))
  end

  defp substract(left, right) when is_number(left) and is_number(right) do
    "#{left - right}"
  end

  defp substract(left, right) when is_binary(left) and is_binary(right) do
    substract(string_to_number(left), string_to_number(right))
  end

  defp substract(left, right) when is_binary(left) do
    substract(string_to_number(left), right)
  end

  defp substract(left, right) when is_binary(right) do
    substract(left, string_to_number(right))
  end

  defp add(left, right) when is_number(left) and is_number(right) do
    "#{left + right}"
  end

  defp add(left, right) when is_binary(left) and is_binary(right) do
    add(string_to_number(left), string_to_number(right))
  end

  defp add(left, right) when is_binary(left) do
    add(string_to_number(left), right)
  end

  defp add(left, right) when is_binary(right) do
    add(left, string_to_number(right))
  end

  defp string_to_number(str) when is_binary(str),
    do: if(String.contains?(str, "."), do: parse_float!(str), else: String.to_integer(str))

  def parse_float!(str) do
    case Float.parse(str) do
      {number, ""} -> number
      _ -> raise "Failed to parse #{str} as float"
    end
  end

  def special_operators, do: [&add/2, &substract/2, &multiply/2, &divide/2, &double_pipe/2]
end
