defmodule AOC2024.Day16.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day16.Part1.Solution.solution(Input.read_file_to_lines!("input.txt"))
      0

  """
  def solution(input) do
    input
    |> get_map_p1()
    |> Map.values()
    |> Tile.print_tile_map()
    0
  end

  def get_map_p1(input) do
    input
    |> Enum.take_while(&String.starts_with?(&1, "#"))
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, y}, acc ->
      columns =
        line
        |> String.to_charlist()
        |> Enum.map(&<<&1>>)
        |> Enum.with_index()
        |> Enum.reduce([], fn {tile, x}, col_acc ->
          tile =
            case tile do
              "S" -> [%Tile{x: x, y: y, type: :reindeer, display: "S"}]
              "#" -> [%Tile{x: x, y: y, type: :obstacle, display: "#"}]
              "E" -> [%Tile{x: x, y: y, type: :goal, display: "E"}]
              "." -> [%Tile{x: x, y: y, type: :space, display: "."}]
            end

          tile ++ col_acc
        end)

      columns ++ acc
    end)
    |> Enum.reverse()
    |> Enum.map(fn tile -> {{tile.x, tile.y}, tile} end)
    |> Enum.into(%{})
  end
end
