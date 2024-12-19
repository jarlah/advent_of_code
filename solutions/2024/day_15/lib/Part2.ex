defmodule AOC2024.Day15.Part2.Solution do
  import AOC2024.Day15.Part1.Solution, only: [get_moves: 1]

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_string_to_lines!(\"""
      ...>########
      ...>#..O..##
      ...>#...O..#
      ...>#...O..#
      ...>#.@....#
      ...>########
      ...>
      ...>^>>>><^><<<^>>>>>
      ...>\"""))
      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_string_to_lines!(\"""
      ...>######
      ...>#...##
      ...>#O.O.#
      ...>#.O..#
      ...>#.@..#
      ...>######
      ...>
      ...>^<^^
      ...>\"""))
      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_file_to_lines!("input.txt"))
      0

  """
  def solution(input) do
    grid_map =
      input
      |> prepare_input()
      |> get_map_p2()

    moves =
      input
      |> get_moves()

    perform_moves(grid_map, moves)

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
                  id = UUID.uuid4()

                  chunk
                  |> Enum.map(fn {_, offset} ->
                    %Tile{id: id, x: x + offset, y: y, type: :box, display: "O"}
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

  def perform_moves(grid_map, moves) do
    robot = Enum.find(grid_map, &(elem(&1, 1).type === :robot)) |> elem(1)
    perform_moves(grid_map, moves, robot)
  end

  def perform_moves(map, [], _robot), do: map

  def perform_moves(map, [move | rest_moves], %Tile{x: robot_x, y: robot_y} = robot) do
    {dx, dy} =
      case move do
        :right -> {1, 0}
        :left -> {-1, 0}
        :down -> {0, 1}
        :up -> {0, -1}
      end

    next_robot = Tile.move(robot, dx, dy)

    # map
    # |> Map.values()
    # |> Tile.print_tile_map(layout: :simple)

    case Map.get(map, {next_robot.x, next_robot.y}) do
      %Tile{type: :box} ->
        # lets try to push the robot and the boxes in front of it
        {updated_map, can_move} = push_boxes(map, robot_x, robot_y, dx, dy)

        if can_move do
          perform_moves(updated_map, rest_moves, Tile.move(robot, dx, dy))
        else
          perform_moves(map, rest_moves, robot)
        end

      %Tile{type: :obstacle} ->
        # do nothing, continue
        perform_moves(map, rest_moves, robot)

      _ ->
        # there are no box or no obstacle, just move the robot
        perform_moves(
          move_tile(map, robot, dx, dy),
          rest_moves,
          Tile.move(robot, dx, dy)
        )
    end
  end

  def push_boxes(map, robot_x, robot_y, dx, dy) do
    push_boxes(map, robot_x + dx, robot_y + dy, dx, dy, %{
      {robot_x, robot_y} => Map.get(map, {robot_x, robot_y})
    })
  end

  def push_boxes(map, x, y, dx, dy, tiles) do
    case Map.get(map, {x, y}) do
      %Tile{id: box_id, type: :box} ->
        boxes_with_id =
          Enum.filter(map, fn {_pos, tile} -> tile.id == box_id end) |> Enum.map(&elem(&1, 1))

        new_tiles =
          Enum.reduce(boxes_with_id, tiles, fn tile, tiles_acc ->
            Map.put(tiles_acc, {tile.x, tile.y}, tile)
          end)

        push_boxes(map, x + dx, y + dy, dx, dy, new_tiles)

      %Tile{type: :obstacle} ->
        {map, false}

      %Tile{type: :space} ->
        move_boxes(map, tiles, dx, dy)

      nil ->
        move_boxes(map, tiles, dx, dy)
    end
  end

  def move_boxes(map, tiles, dx, dy) do
    # Sort positions based on movement direction
    sorted_tiles = sort_tiles(tiles |> Map.values(), dx, dy)

    # Simulate the move
    {_, can_move} =
      Enum.reduce(sorted_tiles, {map, true}, fn %Tile{x: x, y: y} = tile, {sim_map, can_move} ->
        if can_move do
          new_pos = {x + dx, y + dy}

          case Map.get(sim_map, new_pos) do
            %Tile{type: :space} ->
              {move_tile(sim_map, tile, dx, dy), true}

            nil ->
              {move_tile(sim_map, tile, dx, dy), true}

            _ ->
              {sim_map, false}
          end
        else
          {sim_map, false}
        end
      end)

    if can_move do
      # If all boxes can be moved, perform the actual move
      Enum.reduce(sorted_tiles, {map, true}, fn %Tile{} = tile, {acc_map, _} ->
        {move_tile(acc_map, tile, dx, dy), true}
      end)
    else
      {map, false}
    end
  end

  defp move_tile(map, tile, dx, dy) do
    map
    |> Map.put({tile.x + dx, tile.y + dy}, Tile.move(tile, dx, dy))
    |> Map.delete({tile.x, tile.y})
  end

  defp sort_tiles(tiles, dx, dy) do
    cond do
      dx > 0 -> Enum.sort_by(tiles, fn %Tile{x: x, y: y, id: id} -> {-x, y, id} end)
      dx < 0 -> Enum.sort_by(tiles, fn %Tile{x: x, y: y, id: id} -> {x, y, id} end)
      dy > 0 -> Enum.sort_by(tiles, fn %Tile{x: x, y: y, id: id} -> {-y, x, id} end)
      dy < 0 -> Enum.sort_by(tiles, fn %Tile{x: x, y: y, id: id} -> {y, x, id} end)
      true -> tiles
    end
  end

  defp prepare_input(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.replace("#", "##")
      |> String.replace("O", "OO")
      |> String.replace(".", "..")
      |> String.replace("@", "@.")
    end)
  end
end
