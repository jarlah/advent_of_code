defmodule AOC2024.Day12.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day12.Part1.Solution.solution(AOC2024.Day12.Input.test_input_1())
      %{discounted: 80, total: 140}
      iex> AOC2024.Day12.Part1.Solution.solution(AOC2024.Day12.Input.test_input_2())
      %{discounted: 436, total: 772}
      iex> AOC2024.Day12.Part1.Solution.solution(AOC2024.Day12.Input.test_input())
      %{discounted: 1206, total: 1930}
      iex> AOC2024.Day12.Part1.Solution.solution(AOC2024.Day12.Input.input())
      %{discounted: 885394, total: 1421958}
      iex> AdventOfCode.Solutions.Y24.OtherSolutionDay12.part_two(AOC2024.Day12.Part1.Solution.get_garden(AOC2024.Day12.Input.input()))
      885394

  """
  def solution(input) do
    map = get_garden(input)

    map
    |> Map.values()
    |> Enum.uniq()
    |> Enum.reduce(%{total: 0, discounted: 0}, fn plant, acc ->
      map
      |> Map.filter(&(elem(&1, 1) == plant))
      |> get_gardens()
      |> Enum.reduce(acc, fn garden, acc ->
        area_total = Map.keys(garden) |> length()
        wall_count = get_wall_count_for_garden(plant, garden)
        side_count = get_side_count_for_garden(garden)

        acc
        |> Map.update!(:total, &(&1 + area_total * wall_count))
        |> Map.update!(:discounted, &(&1 + area_total * side_count))
      end)
    end)
  end

  def get_garden(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.to_charlist()
      |> Enum.map(&<<&1>>)
      |> Enum.with_index()
      |> Enum.reduce(
        acc,
        &Map.put(
          &2,
          # position
          {elem(&1, 1), y},
          # region
          elem(&1, 0)
        )
      )
    end)
  end

  defp get_gardens(positions) when is_map(positions) do
    Enum.reduce(positions, [], fn {pos, plant}, areas ->
      {connected_areas, unconnected_areas} =
        Enum.split_with(areas, &connected_to_garden?(pos, Map.keys(&1)))

      case connected_areas do
        [] ->
          [%{pos => plant} | areas]

        _ ->
          merged_area =
            Enum.reduce(connected_areas, %{pos => plant}, fn area, acc ->
              Map.merge(acc, area)
            end)

          [merged_area | unconnected_areas]
      end
    end)
  end

  defp connected_to_garden?(pos, area) when is_tuple(pos) and is_list(area) do
    Enum.any?(area, &adjacent_positions?(pos, &1))
  end

  defp adjacent_positions?({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2) == 1
  end

  defp get_wall_count_for_garden(plant, garden_map)
       when is_binary(plant) and is_map(garden_map) do
    garden_map
    |> Enum.reduce(0, fn {pos, _plant}, acc ->
      acc + get_wall_count_for_position(plant, pos, garden_map)
    end)
  end

  defp get_wall_count_for_position(plant, pos, garden_map)
       when is_binary(plant) and is_tuple(pos) and is_map(garden_map) do
    move_functions_map()
    |> Map.values()
    |> Enum.map(&Map.get(garden_map, &1.(pos)))
    |> Enum.count(fn
      nil -> true
      ^plant -> false
      _ -> true
    end)
  end

  defp get_side_count_for_garden(garden_map) when is_map(garden_map) do
    garden_map
    |> Enum.reduce(0, fn {pos, _plant}, acc ->
      acc + count_corners(garden_map, pos)
    end)
  end

  def count_corners(garden_map, pos) when is_map(garden_map) and is_tuple(pos) do
    [
      corner_at_up_right?(garden_map, pos),
      corner_at_up_left?(garden_map, pos),
      corner_at_down_right?(garden_map, pos),
      corner_at_down_left?(garden_map, pos)
    ]
    |> Enum.filter(&(&1 == true))
    |> Enum.count()
  end

  defp corner_at_up_right?(garden_map, pos), do: corner_at?(garden_map, pos, :up, :right)
  defp corner_at_up_left?(garden_map, pos), do: corner_at?(garden_map, pos, :up, :left)
  defp corner_at_down_right?(garden_map, pos), do: corner_at?(garden_map, pos, :down, :right)
  defp corner_at_down_left?(garden_map, pos), do: corner_at?(garden_map, pos, :down, :left)

  defp corner_at?(garden_map, pos, dir1, dir2)
       when dir1 in [:up, :down] and dir2 in [:right, :left] do
    dirs = move_functions_map()

    plant = garden_map |> Map.get(pos)

    plant_dir1 = Map.get(garden_map, Map.get(dirs, dir1).(pos))
    plant_dir2 = Map.get(garden_map, Map.get(dirs, dir2).(pos))
    plant_diagonal = Map.get(garden_map, Map.get(dirs, dir2).(pos) |> Map.get(dirs, dir1).())

    # for explanation about convex and concave,
    # see https://www.researchgate.net/figure/Examples-of-normal-edge-convex-corner-and-concave-corner-fragments-Normal-edge_fig2_228895487
    # in our case:
    #  the position of the plant we are testing might have a have a plant above it (UP) and another plant to its LEFT
    #     If both of these are different, its a convex corner
    #     If both of these are similar plants, we check the diagonal plant, and if its different, its a concave corner

    convex_corner = plant_dir1 != plant and plant_dir2 != plant
    concave_corner = plant_dir1 == plant and plant_dir2 == plant and plant_diagonal != plant

    convex_corner or concave_corner
  end

  def move_functions_map,
    do: %{
      :up => fn {x, y} -> {x, y + 1} end,
      :right => fn {x, y} -> {x + 1, y} end,
      :down => fn {x, y} -> {x, y - 1} end,
      :left => fn {x, y} -> {x - 1, y} end
    }
end
