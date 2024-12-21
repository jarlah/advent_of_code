defmodule AOC2024.Day16.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day16.Part1.Solution.solution(Input.read_file_to_lines!("input.txt"))
      0 # 452 is too low

  """
  def solution(input) do
    map =
      input
      |> Tile.parse_map()
      |> Enum.map(fn {pos, tile} ->
        case tile.display do
          "S" -> {pos, %Tile{tile | type: :reindeer}}
          "#" -> {pos, %Tile{tile | type: :obstacle}}
          "E" -> {pos, %Tile{tile | type: :goal}}
          "." -> {pos, %Tile{tile | type: :space}}
        end
      end)
      |> Enum.into(%{})

    start_pos = find_start_position(map)
    goal_pos = find_goal_position(map)

    case bfs(map, start_pos, goal_pos) do
      # Subtract 1 to get number of steps (excluding start position)
      {:ok, path} -> length(path) - 1
      :error -> :no_path_found
    end
  end

  defp find_start_position(map) do
    Enum.find_value(map, fn {pos, tile} -> if tile.type == :reindeer, do: pos end)
  end

  defp find_goal_position(map) do
    Enum.find_value(map, fn {pos, tile} -> if tile.type == :goal, do: pos end)
  end

  defp bfs(map, start, goal) do
    queue = :queue.from_list([{start, []}])
    visited = MapSet.new([start])

    bfs_loop(queue, visited, map, goal)
  end

  defp bfs_loop(queue, visited, map, goal) do
    case :queue.out(queue) do
      {{:value, {current, path}}, rest} ->
        if current == goal do
          {:ok, [current | path]}
        else
          {new_queue, new_visited} = explore_neighbors(current, rest, visited, map)
          bfs_loop(new_queue, new_visited, map, goal)
        end

      {:empty, _} ->
        :error
    end
  end

  defp explore_neighbors({x, y}, queue, visited, map) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.reduce({queue, visited}, fn neighbor, {acc_queue, acc_visited} ->
      if can_move_to?(neighbor, map) and not MapSet.member?(acc_visited, neighbor) do
        current_path =
          case :queue.peek(acc_queue) do
            {:value, {_, path}} -> path
            :empty -> []
          end

        {
          :queue.in({neighbor, [{x, y} | current_path]}, acc_queue),
          MapSet.put(acc_visited, neighbor)
        }
      else
        {acc_queue, acc_visited}
      end
    end)
  end

  defp can_move_to?(pos, map) do
    case Map.get(map, pos) do
      %Tile{type: type} when type in [:space, :goal] -> true
      _ -> false
    end
  end
end
