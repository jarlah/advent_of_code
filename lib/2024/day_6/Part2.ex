defmodule AOC2024.Day6.Part2.Solution do
  alias AOC2024.Day6.Tile
  alias AOC2024.Day6.TileParser
  alias AOC2024.Day6.TileFormatter
  alias AOC2024.Day6.TileTraverser

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part2.Solution.solution(AOC2024.Day6.Input.test_input())
      6

      iex> AOC2024.Day6.Part2.Solution.solution(AOC2024.Day6.Input.input())
      0 # unknown

  """
  def solution(input) do
    map = TileParser.parse(input)

    {:ok, progress_agent} = Agent.start_link(fn -> 0 end)
    total_tasks = Enum.count(map, fn tile -> not (tile.is_guard or tile.is_obstacle) end)

    result =
      map
      |> Enum.with_index()
      |> Enum.filter(fn {tile, _index} -> not (tile.is_guard or tile.is_obstacle) end)
      |> Task.async_stream(
        fn {tile, index} ->
          case TileTraverser.traverse_map(
                 List.replace_at(map, index, %Tile{tile | is_obstruction: true}),
                 Enum.find(map, &Tile.is_guard/1)
               ) do
            {:cycling, _} ->
              IO.inspect("Index #{index} is cycling")
              1

            _ ->
              IO.inspect("OK")
              0
          end
          |> tap(fn _ ->
            Agent.update(progress_agent, &(&1 + 1))
            completed = Agent.get(progress_agent, & &1)
            percent_done = Float.round(completed / total_tasks * 100, 2)
            IO.inspect("#{percent_done}% completed")
          end)
        end,
        max_concurrency: 10,
        timeout: 3_000_000_000
      )
      |> Enum.map(fn {:ok, result} -> result end)
      |> Enum.sum()

    Agent.stop(progress_agent)

    result
  end

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part2.Solution.pre_solution(AOC2024.Day6.Input.test_obstacle_input(), true)
      31

  """
  def pre_solution(input, print_tiles \\ false) do
    map = TileParser.parse(input)

    {:cycling, map} = TileTraverser.traverse_map(map, Enum.find(map, &Tile.is_guard/1))

    if print_tiles,
      do: TileFormatter.print_grid(map, hd(input) |> String.length()),
      else: nil

    Enum.count(map, fn %Tile{visited: visited} -> visited end)
  end
end
