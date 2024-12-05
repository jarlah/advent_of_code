defmodule AOC2024.Day4.Part2.Solution do
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
      row_as_list = String.to_charlist(row)

      row_as_list
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {_col, col_idx}, acc ->
        if col_idx > 0 && col_idx < length(row_as_list) && row_idx > 0 && row_idx < length(input) do
          lr_diag = get_diagonal(input, fn i -> {row_idx + i, col_idx + i} end)
          rl_diag = get_diagonal(input, fn i -> {row_idx + i, col_idx - i} end)

          if String.match?(lr_diag, ~r/MAS|SAM/) && String.match?(rl_diag, ~r/MAS|SAM/) do
            [{lr_diag, rl_diag} | acc]
          else
            acc
          end
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

    diagonal =
      for i <- -1..1 do
        {new_row, new_col} = coord_fn.(i)

        if new_row >= 0 and new_row < height and new_col >= 0 and new_col < width do
          input |> Enum.at(new_row) |> String.at(new_col)
        end
      end
      |> Enum.reject(&is_nil/1)
      |> Enum.join()

    diagonal
  end
end
