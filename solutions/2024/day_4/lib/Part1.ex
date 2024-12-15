defmodule AOC2024.Day4.Part1.Solution do
  @regex ~r/XMAS|SAMX/

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day4.Part1.Solution.solution(AOC2024.Day4.Input.horizontal_input())
      18
      iex> AOC2024.Day4.Part1.Solution.solution(AOC2024.Day4.Input.parsed_input())
      2569


  """
  def solution(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, row_idx}, acc ->
      row_as_list = String.to_charlist(row)

      row_as_list
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {_col, col_idx}, acc ->
        horizontal =
          Enum.reduce_while(
            0..3,
            {row_idx, col_idx, row_idx, col_idx, []},
            fn i, {start_row, start_col, end_row, end_col, diag_acc} ->
              next_col = col_idx + i

              if next_col < length(row_as_list) do
                next_char = Enum.at(row_as_list, next_col)
                {:cont, {start_row, start_col, end_row, next_col, diag_acc ++ [next_char]}}
              else
                {:halt, {start_row, start_col, end_row, end_col, diag_acc}}
              end
            end
          )

        vertical =
          Enum.reduce_while(
            0..3,
            {row_idx, col_idx, row_idx, col_idx, []},
            fn i, {start_row, start_col, end_row, end_col, diag_acc} ->
              next_row = row_idx + i

              if next_row < length(input) do
                next_char = input |> Enum.at(next_row) |> String.to_charlist() |> Enum.at(col_idx)
                {:cont, {start_row, start_col, next_row, end_col, diag_acc ++ [next_char]}}
              else
                {:halt, {start_row, start_col, end_row, end_col, diag_acc}}
              end
            end
          )

        diagonal_lr =
          Enum.reduce_while(
            0..3,
            {row_idx, col_idx, row_idx, col_idx, []},
            fn i, {start_row, start_col, end_row, end_col, diag_acc} ->
              next_row = row_idx + i
              next_col = col_idx + i

              if next_row < length(input) and next_col < length(row_as_list) do
                next_char =
                  input |> Enum.at(next_row) |> String.to_charlist() |> Enum.at(next_col)

                {:cont, {start_row, start_col, next_row, next_col, diag_acc ++ [next_char]}}
              else
                {:halt, {start_row, start_col, end_row, end_col, diag_acc}}
              end
            end
          )

        diagonal_rl =
          Enum.reduce_while(
            0..3,
            {row_idx, col_idx, row_idx, col_idx, []},
            fn i, {start_row, start_col, end_row, end_col, diag_acc} ->
              next_row = row_idx + i
              next_col = col_idx - i

              if next_row < length(input) and next_col >= 0 do
                next_char =
                  input |> Enum.at(next_row) |> String.to_charlist() |> Enum.at(next_col)

                {:cont, {start_row, start_col, next_row, next_col, diag_acc ++ [next_char]}}
              else
                {:halt, {start_row, start_col, end_row, end_col, diag_acc}}
              end
            end
          )

        acc
        |> append_if_match(horizontal)
        |> append_if_match(vertical)
        |> append_if_match(diagonal_lr)
        |> append_if_match(diagonal_rl)
      end)
    end)
    |> List.flatten()
    # |> IO.inspect()
    |> length()
  end

  defp append_if_match(acc, {start_row, start_col, end_row, end_col, diagonal}) do
    if diagonal |> List.to_string() |> String.match?(@regex),
      do: acc ++ [{start_row, start_col, end_row, end_col, diagonal}],
      else: acc
  end
end
