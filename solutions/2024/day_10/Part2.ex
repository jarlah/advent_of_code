defmodule AOC2024.Day10.Part2.Solution do
  alias AOC2024.Day10.Tile

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day10.Part2.Solution.solution(AOC2024.Day10.Input.test_input())
      81
      iex> AOC2024.Day10.Part2.Solution.solution(AOC2024.Day10.Input.input())
      1942

  """
  def solution(input) do
    map = get_map(input)
    solve(map)
  end

  def get_map(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.to_charlist()
      |> Enum.map(&String.to_integer(<<&1>>))
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {number, x}, acc ->
        Map.put(acc, {x, y}, %Tile{
          pos: {x, y},
          number: number,
          is_trail_head: number == 0,
          score: 0
        })
      end)
    end)
  end

  defp solve(map) do
    map
    |> Map.filter(fn {_, tile} -> tile.is_trail_head end)
    |> Map.values()
    |> Enum.reduce(map, &find_all_hikes/2)
    |> Map.filter(fn {_, tile} -> tile.is_trail_head end)
    |> Enum.map(fn {_, tile} -> tile.score end)
    |> Enum.sum()
  end

  def find_all_hikes(trail_head, map) do
    all_nines = Map.filter(map, fn {_, tile} -> tile.number == 9 end)

    score =
      Enum.reduce(all_nines, 0, fn {_nine_idx, nine_tile}, acc ->
        acc + get_all_paths_to_target(trail_head, nine_tile, map, %{})
      end)

    Map.update!(map, trail_head.pos, fn tile -> %Tile{tile | score: tile.score + score} end)
  end

  defp get_all_paths_to_target(trail_head, target_tile, _map, _visited)
       when trail_head.pos == target_tile.pos,
       do: 1

  defp get_all_paths_to_target(trail_head, target_tile, map, visited) do
    new_visited = Map.put(visited, trail_head.pos, true)
    possible_moves = Tile.possible_moves(trail_head)

    Enum.reduce(possible_moves, 0, fn next_tile_pos, acc ->
      next_tile = Map.get(map, next_tile_pos)

      if next_tile && next_tile.number == trail_head.number + 1 &&
           !Map.get(new_visited, next_tile_pos) do
        acc + get_all_paths_to_target(next_tile, target_tile, map, new_visited)
      else
        acc
      end
    end)
  end
end
