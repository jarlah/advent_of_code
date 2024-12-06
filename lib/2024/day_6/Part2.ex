defmodule AOC2024.Day6.Part2.Solution do
  alias AOC2024.Day6.Tile
  alias AOC2024.Day6.TileParser
  alias AOC2024.Day6.TileFormatter
  alias AOC2024.Day6.TileTraverser

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day6.Part2.Solution.solution(AOC2024.Day6.Input.test_input(), true)
      6

      iex> AOC2024.Day6.Part2.Solution.solution(AOC2024.Day6.Input.input(), false)
      0 # unknown

  """
  def solution(input, _print_tiles \\ false) do
    map = TileParser.parse(input)

    Enum.with_index(map)
    |> Enum.reduce(0, fn {tile, index}, acc ->
      if tile.is_guard or tile.is_obstacle do
        acc
      else
        case TileTraverser.traverse_map(
               List.replace_at(map, index, %Tile{tile | is_obstruction: true}),
               Enum.find(map, &Tile.is_guard/1)
             ) do
          {:cycling, _} -> acc + 1
          _ -> acc
        end
      end
    end)
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
