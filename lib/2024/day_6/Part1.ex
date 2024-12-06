defmodule AOC2024.Day6.Part1.Solution do
  alias AOC2024.Day6.Tile

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.test_input())
      41

      iex> AOC2024.Day6.Part1.Solution.solution(AOC2024.Day6.Input.input())
      5131

  """
  def solution(input) do
    map =
      input
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.map(fn {col, x} ->
          %Tile{x: x, y: y, c: <<col>>, obstacle: <<col>> == "#", guard: <<col>> == "^"}
        end)
      end)
      |> List.flatten()

    guard = map |> Enum.find(&is_guard/1)

    map = traverse_map(map, guard, :up)

    # map |> TileFormatter.print_grid(hd(input) |> String.length())

    map
    |> Enum.filter(fn %Tile{c: char} -> char == "X" end)
    |> length()
  end

  defp traverse_map(map, %Tile{x: guard_x, y: guard_y} = guard, direction)
       when is_list(map) and is_atom(direction) do
    current_guard_index = map |> find_index_by_coord(guard_x, guard_y)
    new_guard = move_guard(guard, direction)
    new_guard_idx = map |> find_index_by_coord(new_guard.x, new_guard.y)

    if new_guard_idx && new_guard.y < length(map) && new_guard.y >= 0 do
      if map |> Enum.at(new_guard_idx, %Tile{}) |> is_obstacle() do
        new_direction = change_direction(direction)

        traverse_map(
          cross_out(map, current_guard_index),
          move_guard(guard, new_direction),
          new_direction
        )
      else
        traverse_map(cross_out(map, current_guard_index), new_guard, direction)
      end
    else
      cross_out(map, current_guard_index)
    end
  end

  defp cross_out(map, index) do
    tile = Enum.at(map, index)
    map |> List.replace_at(index, %Tile{tile | c: "X"})
  end

  defp is_guard(%Tile{guard: guard}), do: guard
  defp is_obstacle(%Tile{obstacle: obstacle}), do: obstacle

  defp change_direction(:up), do: :right
  defp change_direction(:right), do: :down
  defp change_direction(:down), do: :left
  defp change_direction(:left), do: :up

  defp move_guard(%Tile{x: x, y: y} = guard, :up), do: %Tile{guard | x: x, y: y - 1, c: "^"}
  defp move_guard(%Tile{x: x, y: y} = guard, :down), do: %Tile{guard | x: x, y: y + 1, c: "v"}
  defp move_guard(%Tile{x: x, y: y} = guard, :right), do: %Tile{guard | x: x + 1, y: y, c: ">"}
  defp move_guard(%Tile{x: x, y: y} = guard, :left), do: %Tile{guard | x: x - 1, y: y, c: "<"}

  defp find_index_by_coord(map, target_x, target_y),
    do: map |> Enum.find_index(fn %Tile{x: x, y: y} -> x == target_x && y == target_y end)
end
