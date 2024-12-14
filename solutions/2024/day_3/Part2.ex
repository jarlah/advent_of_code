defmodule AOC2024.Day3.Part2.Solution do
  @multiply_regex ~r/mul\((\d{1,3}),(\d{1,3})\)$/

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day3.Part2.Solution.solution(AOC2024.Day3.Input.test_input_dodont())
      48

  """
  def solution(input) do
    input
    |> String.to_charlist()
    |> List.foldl({:enabled, "", 0}, &process_char/2)
    |> then(&(Tuple.to_list(&1) |> List.last()))
  end

  defp process_char(char, {:disabled, str, sum}) do
    if String.ends_with?(str, "do()"),
      do: {:enabled, <<char>>, sum},
      else: {:disabled, str <> <<char>>, sum}
  end

  defp process_char(char, {:enabled, str, sum}) do
    cond do
      String.ends_with?(str, "don't()") ->
        {:disabled, str <> <<char>>, sum}

      String.match?(str, @multiply_regex) ->
        [_, a, b] = Regex.run(@multiply_regex, str)
        {:enabled, <<char>>, sum + String.to_integer(a) * String.to_integer(b)}

      true ->
        {:enabled, str <> <<char>>, sum}
    end
  end
end
