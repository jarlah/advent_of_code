defmodule AOC2024.Day15.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_file_to_lines!("input.txt"))
      0

  """
  def solution(input) do
    grid_map =
      input
      |> prepare_input()
      |> get_map_p2()

    box_id_map =
      grid_map
      |> Map.filter(fn {_, tile} -> tile.id != nil end)
      |> Enum.map(fn {_key, tile} -> {tile.id, tile} end)
      |> Enum.into(%{})

    # these will be different since the get_map_p2 function will chunk_by character and assign same id to every chunk
    IO.puts(
      "Number of tiles on map: #{map_size(grid_map)}, number of unique boxes: #{map_size(box_id_map)}"
    )

    grid_map
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
          IO.inspect("X: #{x}, Y: #{y}")
          tiles =
            case tiles do
              ["@"] ->
                [%Tile{id: nil, x: x, y: y, type: :robot, display: "@"}]

              ["#" | _tail] = obstacles ->
                obstacles
                |> Enum.with_index()
                |> Enum.map(fn {_, offset} ->
                  %Tile{id: nil, x: x + offset, y: y, type: :obstacle, display: "#"}
                end)

              ["O" | _tail] = boxes ->
                boxes
                |> Enum.with_index()
                |> Enum.chunk_every(2)
                |> Enum.map(fn chunk ->
                  chunk
                  |> Enum.map(fn {_, offset} ->
                    %Tile{id: UUID.uuid4(), x: x + offset, y: y, type: :box, display: "O"}
                  end)
                end)
                |> List.flatten()

              ["." | _tail] = spaces ->
                spaces
                |> Enum.with_index()
                |> Enum.map(fn {_, offset} ->
                  %Tile{id: nil, x: x + offset, y: y, type: :space, display: "."}
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
end
