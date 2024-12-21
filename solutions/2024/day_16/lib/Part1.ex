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
      {:ok, _path, total_cost} -> total_cost
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
    # {position, path, total_cost, direction}
    queue = :queue.from_list([{start, [], 0, :forward}])
    visited = MapSet.new([start])

    bfs_loop(queue, visited, map, goal)
  end

  defp bfs_loop(queue, visited, map, goal) do
    case :queue.out(queue) do
      {{:value, {current, path, total_cost, _direction}}, rest} ->
        if current == goal do
          {:ok, Enum.reverse(path), total_cost}
        else
          {new_queue, new_visited} =
            explore_neighbors(current, rest, visited, map, total_cost, path)

          bfs_loop(new_queue, new_visited, map, goal)
        end

      {:empty, _} ->
        :error
    end
  end

  defp explore_neighbors({x, y}, queue, visited, map, total_cost, path) do
    prev_direction = get_previous_direction(path)

    [{x + 1, y, :right}, {x - 1, y, :left}, {x, y + 1, :forward}]
    |> Enum.reduce({queue, visited}, fn {new_x, new_y, new_direction}, {q, v} ->
      neighbor = {new_x, new_y}

      if can_move_to?(neighbor, map) and not MapSet.member?(v, neighbor) and
           not opposite?(prev_direction, new_direction) do
        move_cost = calculate_move_cost(new_direction)
        new_total_cost = total_cost + move_cost

        {
          :queue.in({neighbor, [{x, y} | path], new_total_cost, new_direction}, q),
          MapSet.put(v, neighbor)
        }
      else
        {q, v}
      end
    end)
  end

  defp can_move_to?(pos, map) do
    case Map.get(map, pos) do
      %Tile{type: type} when type in [:space, :goal] -> true
      _ -> false
    end
  end

  defp get_previous_direction([]), do: :forward
  defp get_previous_direction([{_x, _y}]), do: :forward
  defp get_previous_direction([{x, y}, {prev_x, prev_y} | _]) do
    cond do
      y > prev_y -> :forward
      x > prev_x -> :right
      x < prev_x -> :left
      true -> raise "Fallback, shouldn't happen"
    end
  end

  defp opposite?(:forward, _), do: false
  defp opposite?(:left, :right), do: true
  defp opposite?(:right, :left), do: true
  defp opposite?(_, _), do: false

  defp calculate_move_cost(:forward), do: 1
  defp calculate_move_cost(_), do: 1000
end
