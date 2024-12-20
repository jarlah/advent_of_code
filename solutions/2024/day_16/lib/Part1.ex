defmodule AOC2024.Day16.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day16.Part1.Solution.solution(Input.read_file_to_lines!("input.txt"))
      0

  """
  def solution(input) do
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
    |> Map.values()
    |> Tile.print_tile_map()
    0
  end
end
