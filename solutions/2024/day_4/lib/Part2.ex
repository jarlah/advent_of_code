defmodule AOC2024.Day4.Part2.Solution do
  @regex ~r/MAS|SAM/

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day4.Part2.Solution.solution(AOC2024.Day4.Input.horizontal_input())
      9
      iex> AOC2024.Day4.Part2.Solution.solution(AOC2024.Day4.Input.parsed_input())
      1998

  """
  def solution(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, row_idx}, acc ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {_col, col_idx}, acc ->
        lr_diag = get_diagonal(input, fn i -> {row_idx + i, col_idx + i} end)
        rl_diag = get_diagonal(input, fn i -> {row_idx + i, col_idx - i} end)

        if String.match?(lr_diag, @regex) && String.match?(rl_diag, @regex) do
          [{lr_diag, rl_diag} | acc]
        else
          acc
        end
      end)
    end)
    # |> IO.inspect()
    |> Enum.count()
  end

  defp get_diagonal(input, coord_fn) do
    height = length(input)
    width = String.length(List.first(input))

    for i <- -1..1 do
      {new_row, new_col} = coord_fn.(i)

      if new_row >= 0 and new_row < height and new_col >= 0 and new_col < width do
        input |> Enum.at(new_row) |> String.at(new_col)
      end
    end
    |> Enum.join()
  end
end
