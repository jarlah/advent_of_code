defmodule AOC2024.Day9.Part2.Solution do
  @doc ~S"""
  ## Examples

      NB!! This one is shame, shame, shame. I say no more. I did not solve this myself and had to resort to some help. Hopefylly i have learned something

      iex> AOC2024.Day9.Part2.Solution.solution(AOC2024.Day9.Input.input())
      6307653242596
      iex> AOC2024.Day9.Part2.Solution.solution(AOC2024.Day9.Input.test_input())
      2858

  """
  def solution(input) do
    {blocks, free_ranges, _} =
      input
      |> String.to_charlist()
      |> Enum.map(&String.to_integer(<<&1>>))
      |> Enum.chunk_every(2, 2)
      |> Enum.with_index()
      |> Enum.reduce({%{}, %{}, 0}, &process_chunk(&1, &2))

    get_checksum(blocks, free_ranges, 0, Enum.max(blocks))
  end

  defp get_checksum(_blocks, _free_ranges, checksum, nil), do: checksum

  defp get_checksum(blocks, free_ranges, checksum, {block_id, {block_range, block_size}}) do
    maybe_free_range =
      free_ranges
      |> Map.filter(fn {_, free_range} ->
        not (block_size > Range.size(free_range) or free_range.first > block_range.first)
      end)
      |> Enum.min(fn -> nil end)

    {updated_free_ranges, new_checksum} =
      case maybe_free_range do
        {free_range_idx, free_range} ->
          {overlapping_range, remaining_free} = Range.split(free_range, block_size)

          updated_free_ranges =
            if Range.size(remaining_free) > 0,
              do: free_ranges |> Map.put(free_range_idx, remaining_free),
              else: free_ranges |> Map.delete(free_range_idx)

          new_checksum = checksum + block_id * Enum.sum(overlapping_range)
          {updated_free_ranges, new_checksum}

        nil ->
          new_checksum = checksum + block_id * Enum.sum(block_range)
          {free_ranges, new_checksum}
      end

    next_block =
      case Map.fetch(blocks, block_id - 1) do
        {:ok, value} -> {block_id - 1, value}
        :error -> nil
      end

    get_checksum(blocks, updated_free_ranges, new_checksum, next_block)
  end

  defp process_chunk(
         {[number | maybe_free_space], next_block_id},
         {blocks, free_ranges, current_count}
       ) do
    next_free_size = List.first(maybe_free_space, 0)

    start_idx_free_space = current_count + number

    new_free_ranges =
      if next_free_size > 0 do
        Map.put(
          free_ranges,
          start_idx_free_space,
          start_idx_free_space..(start_idx_free_space + next_free_size - 1)
        )
      else
        free_ranges
      end

    # we add the number since the number should repeat "number" times
    # we also add the next free space since that will amount to next free space amount of dots.
    new_current_count = start_idx_free_space + next_free_size

    block_range = current_count..(start_idx_free_space - 1)
    new_blocks = blocks |> Map.put(next_block_id, {block_range, Range.size(block_range)})

    {new_blocks, new_free_ranges, new_current_count}
  end
end
