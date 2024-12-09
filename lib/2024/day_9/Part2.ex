defmodule AOC2024.Day9.Part2.Solution do
  @doc ~S"""
  ## Examples

      NB!! This one is shame, shame, shame. I say no more. I did not solve this myself and had to resort to some help. Hopefylly i have learned something

      iex> AOC2024.Day9.Part2.Solution.solution(AOC2024.Day9.Input.input())
      6307653242596

  """
  def solution(input) do
    {blocks, free_ranges, _} = parse_input(input)

    blocks
    |> Enum.reverse()
    |> Enum.reduce({free_ranges, 0}, &process_block(&1, &2))
    |> elem(1)
  end

  defp process_block({block_id, block_range}, {available_ranges, checksum}) do
    block_size = Range.size(block_range)

    {left_ranges, right_ranges} =
      Enum.split_while(available_ranges, &fits_condition?(block_size, block_range, &1))

    case right_ranges do
      [fits | remaining] ->
        handle_fitting_range(block_id, block_size, fits, remaining, left_ranges, checksum)

      [] ->
        handle_non_fitting_range(block_id, block_range, checksum, available_ranges)
    end
  end

  defp fits_condition?(block_size, block_range, free_range) do
    block_size > Range.size(free_range) or free_range.first > block_range.first
  end

  defp handle_fitting_range(block_id, block_size, fits, remaining, left_ranges, checksum) do
    {overlap, remaining_free} = Range.split(fits, block_size)

    updated_free_ranges =
      if remaining_free.step == 1 do
        left_ranges ++ [remaining_free | remaining]
      else
        left_ranges ++ remaining
      end

    new_checksum = checksum + block_id * Enum.sum(overlap)

    {updated_free_ranges, new_checksum}
  end

  defp handle_non_fitting_range(block_id, block_range, checksum, available_ranges) do
    new_checksum = checksum + block_id * Enum.sum(block_range)
    {available_ranges, new_checksum}
  end

  defp parse_input(file) do
    file
    |> String.to_charlist()
    |> Enum.map(&String.to_integer(<<&1>>))
    |> Enum.chunk_every(2, 2)
    |> Enum.with_index()
    |> Enum.reduce({[], [], 0}, &process_chunk(&1, &2))
  end

  defp process_chunk({[nb | rest], id}, {blocks, free_ranges, current_count}) do
    next_free_size = List.first(rest) || 0

    new_free_range = calculate_free_range(current_count, nb, next_free_size)

    new_blocks = add_block(blocks, id, current_count, nb)
    new_free_ranges = free_ranges ++ [new_free_range]
    new_current_count = current_count + nb + next_free_size

    {new_blocks, new_free_ranges, new_current_count}
  end

  defp calculate_free_range(current_count, nb, next_free_size) do
    if next_free_size > 0 do
      (current_count + nb)..(current_count + nb + next_free_size - 1)
    else
      ..
    end
  end

  defp add_block(blocks, id, current_count, nb) do
    blocks ++ [{id, current_count..(current_count + nb - 1)}]
  end
end
