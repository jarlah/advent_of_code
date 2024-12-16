defmodule AOC2024.Day15.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_file_to_lines!("input.txt"))
      0

  """
  def solution(input) do
    input
    |> prepare_input()
    |> get_map_p2()
    |> Map.values()
    |> Tile.print_tile_map(layout: :simple)

    0
  end

  def get_map_p2(input) do
    input
    |> Enum.take_while(&String.starts_with?(&1, "#"))
    |> Enum.reduce({0, []}, fn line, {y, acc} ->
      columns =
        line
        |> String.graphemes()
        |> Enum.chunk_by(& &1)
        |> Enum.reduce({0, []}, fn tiles, {x, col_acc} ->
          id = uniq_id()

          tiles =
            case tiles |> Enum.with_index() do
              [{"@", _} | _tail] = robots ->
                robots
                |> Enum.map(fn {_, offset} ->
                  %Tile{id: id, x: x + offset, y: y, type: :robot, display: "@"}
                end)

              [{"#", _} | _tail] = obstacles ->
                obstacles
                |> Enum.map(fn {_, offset} ->
                  %Tile{id: id, x: x + offset, y: y, type: :obstacle, display: "#"}
                end)

              [{"O", _} | _tail] = boxes ->
                boxes
                |> Enum.map(fn {_, offset} ->
                  %Tile{id: id, x: x + offset, y: y, type: :box, display: "O"}
                end)

              [{".", _} | _tail] = boxes ->
                boxes
                |> Enum.map(fn {_, offset} ->
                  %Tile{id: id, x: x + offset, y: y, type: :space, display: "."}
                end)
            end

          {x + length(tiles), tiles ++ col_acc}
        end)

      {y + 1, elem(columns, 1) ++ acc}
    end)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.map(fn tile -> {{tile.x, tile.y}, tile} end)
    |> Enum.into(%{})
  end

  def prepare_input(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.replace("#", "##")
      |> String.replace("O", "OO")
      |> String.replace(".", "..")
    end)
  end

  defp uniq_id, do: to_string(:erlang.ref_to_list(:erlang.make_ref()))
end
