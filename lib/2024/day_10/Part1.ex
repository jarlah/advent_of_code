defmodule AOC2024.Day10.Tile do
  defstruct pos: nil,
            number: nil,
            trail_head: nil,
            score: nil,
            processed: nil
end

defmodule AOC2024.Day10.Part1.Solution do
  alias AOC2024.Day10.Tile

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day10.Part1.Solution.solution(AOC2024.Day10.Input.input())

  """
  def solution(input) do
    map =
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
            trail_head: number == 0,
            score: 0,
            processed: false
          })
        end)
      end)
      |> IO.inspect(limit: :infinity)

    solve_part1(map)
  end

  defp solve_part1(map) do
    map
    |> Map.filter(fn {_, tile} -> tile.trail_head end)
    |> Map.values()
    |> Enum.reduce(map, &walk_trails/2)
  end

  defp walk_trails(%Tile{pos: {x, y}} = head, map, next \\ 1) do
    IO.inspect(head, label: "head")
    IO.inspect(next, label: "next")
    if Map.get(map, {x + 1, y}, %Tile{}).number == next do
      walk_trails(head, map, next + 1)
    end
  end
end
