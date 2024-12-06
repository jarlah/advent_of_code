defmodule AOC2024.Day6.Part1.Solution do
  alias AOC2024.Day6.Tile
  alias AOC2024.Day6.TileParser
  alias AOC2024.Day6.TileFormatter

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.test_input(), true)
      41

      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.input())
      5131

  """
  def solution(input, print_tiles \\ false) do
    map = TileParser.parse(input)

    guard = map |> Enum.find(&Tile.is_guard/1)

    map = traverse_map(map, guard)

    if print_tiles,
      do: map |> TileFormatter.print_grid(hd(input) |> String.length()),
      else: nil

    map
    |> Enum.filter(fn %Tile{visited: visited} -> visited end)
    |> length()
  end

  defp traverse_map(map, %Tile{x: guard_x, y: guard_y, direction: direction} = guard)
       when is_list(map) and is_atom(direction) do
    guard_index = map |> find_index_by_coord(guard_x, guard_y)
    new_guard = Tile.move(guard)
    new_guard_idx = map |> find_index_by_coord(new_guard.x, new_guard.y)

    if new_guard_idx && new_guard.y < length(map) && new_guard.y >= 0 do
      if map |> Enum.at(new_guard_idx, %Tile{}) |> Tile.is_obstacle() do
        guard = Tile.turn(guard)

        traverse_map(
          cross_out(map, guard_index),
          Tile.move(guard)
        )
      else
        traverse_map(cross_out(map, guard_index), new_guard)
      end
    else
      cross_out(map, guard_index)
    end
  end

  defp cross_out(map, index) do
    tile = Enum.at(map, index)
    map |> List.replace_at(index, Tile.visit(tile))
  end

  defp find_index_by_coord(map, target_x, target_y),
    do: map |> Enum.find_index(fn %Tile{x: x, y: y} -> x == target_x && y == target_y end)
end
