defmodule AOC2024.Day11.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day11.Part1.Solution.solution(AOC2024.Day11.Input.test_input(), 6, true)
      22
      iex> AOC2024.Day11.Part1.Solution.solution(AOC2024.Day11.Input.input(), 25)
      185205
  """
  def solution(input, blinks, log \\ false) do
    input
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({0, %{}}, fn stone, {sum, memo} ->
      calculate_stone_count_for_number_of_blinks(stone, blinks, memo, log)
      |> then(
        &{
          sum +
            (elem(&1, 0)
             |> tap(
               if log,
                 do: fn sum -> IO.inspect(sum, label: "Count for stone #{stone}") end,
                 else: fn _ -> nil end
             )),
          elem(&1, 1)
        }
      )
    end)
    |> elem(0)
    |> tap(if log, do: &IO.inspect(&1, label: "Total stone count"), else: & &1)
  end

  defp calculate_stone_count_for_number_of_blinks(stone, blinks_left, memo, log) do
    case memo |> Map.get({:blink, blinks_left, stone}) do
      nil ->
        get_stone_count_for_number_of_blinks(stone, blinks_left, memo, log)
        |> then(
          &{
            elem(&1, 0)
            |> tap(
              if log,
                do: fn sum -> IO.inspect(sum, label: "Intermediate count for #{stone}") end,
                else: fn _ -> nil end
            ),
            elem(&1, 1) |> Map.put({:blink, blinks_left, stone}, elem(&1, 0))
          }
        )

      count ->
        {count, memo}
    end
  end

  defp get_stone_count_for_number_of_blinks(_stone, 0, memo, _log), do: {1, memo}

  defp get_stone_count_for_number_of_blinks(stone, blinks_left, memo, log) do
    transformed = transform_stone(stone)

    Enum.map_reduce(
      transformed,
      memo,
      &calculate_stone_count_for_number_of_blinks(&1, blinks_left - 1, &2, log)
    )
    |> then(
      &{
        Enum.sum(elem(&1, 0)),
        elem(&1, 1)
      }
    )
  end

  defp transform_stone(0), do: [1]

  defp transform_stone(stone) do
    digits = trunc(:math.log10(stone)) + 1

    if rem(digits, 2) == 0 do
      half_digits = div(digits, 2)
      divisor = trunc(:math.pow(10, half_digits))
      [div(stone, divisor), rem(stone, divisor)]
    else
      [stone * 2024]
    end
  end
end
