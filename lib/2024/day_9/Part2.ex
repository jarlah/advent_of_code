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
      |> Enum.reduce({%{}, [], 0}, &process_chunk(&1, &2))

    get_checksum(blocks, free_ranges, 0, Enum.max(blocks))
  end

  defp get_checksum(_blocks, _free_ranges, checksum, nil), do: checksum

  defp get_checksum(blocks, free_ranges, checksum, {block_id, {block_range, block_size}}) do
    {left_ranges, right_ranges} =
      Enum.split_while(
        free_ranges,
        # IF block_size is larger than the free_range size
        # OR if free_range first index is after block_range first index
        # THEN we return true.
        # ELSE we return false (then we have a free_range that is large enough AND before the block_range)
        &(block_size > Range.size(&1) or &1.first > block_range.first)
      )

    {updated_free_ranges, new_checksum} =
      case right_ranges do
        [fits | remaining] ->
          {overlapping_range, remaining_free} = Range.split(fits, block_size)
          updated_free_ranges = left_ranges ++ [remaining_free | remaining]
          new_checksum = checksum + block_id * Enum.sum(overlapping_range)
          {updated_free_ranges, new_checksum}

        [] ->
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

    # we append a new range to free ranges if next_free_size is not zero
    new_free_ranges =
      if next_free_size > 0,
        do:
          free_ranges ++
            [
              (current_count + number)..(current_count + number + next_free_size - 1)
            ],
        else: free_ranges

    # we add the number since the number should repeat "number" times
    # we also add the next free space since that will amount to next free space amount of dots.
    new_current_count = current_count + number + next_free_size

    block_range = current_count..(current_count + number - 1)
    new_blocks = Map.put(blocks, next_block_id, {block_range, Range.size(block_range)})

    {new_blocks, new_free_ranges, new_current_count}
  end
end
