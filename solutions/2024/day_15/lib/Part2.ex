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
      628
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
      512
      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_string_to_lines!(\"""
      ...>#######
      ...>#...#.#
      ...>#.....#
      ...>#..OO@#
      ...>#..O..#
      ...>#.....#
      ...>#######
      ...><vv<<^^<<^^
      ...>\"""))
      618
      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_string_to_lines!(\"""
      ...>##########
      ...>#..O..O.O#
      ...>#......O.#
      ...>#.OO..O.O#
      ...>#..O@..O.#
      ...>#O#..O...#
      ...>#O..O..O.#
      ...>#.OO.O.OO#
      ...>#....O...#
      ...>##########
      ...><vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
      ...>vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
      ...>><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
      ...><<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
      ...>^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
      ...>^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
      ...>>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
      ...><><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
      ...>^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
      ...>v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
      ...>\"""))
      9021
      iex> AOC2024.Day15.Part2.Solution.solution(Input.read_file_to_lines!("input.txt"))
      1432898

  """
  def solution(input) do
    input
    |> prepare_input()
    |> Tile.parse_map()
    |> Enum.map(fn {pos, tile} ->
      case tile.display do
        "@" -> {pos, %Tile{tile | type: :robot}}
        "#" -> {pos, %Tile{tile | type: :obstacle}}
        "O" -> {pos, %Tile{tile | type: :box}}
        "." -> {pos, %Tile{tile | type: :space}}
      end
    end)
    |> Enum.into(%{})
    |> assign_box_ids()
    |> tap(&(Map.values(&1) |> Tile.print_tile_map()))
    |> perform_moves(get_moves(input))
    |> tap(&(Map.values(&1) |> Tile.print_tile_map()))
    |> calculate_box_coordinates()
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp assign_box_ids(grid_map) do
    grid_map
    |> Map.keys()
    # Sort by y first, then x
    |> Enum.sort_by(fn {x, y} -> {y, x} end)
    |> Enum.reduce(grid_map, fn {x, y}, acc_map ->
      tile = Map.get(acc_map, {x, y})

      if tile.type == :box and tile.id == nil do
        right_tile = Map.get(acc_map, {x + 1, y})

        if right_tile != nil and right_tile.type == :box and right_tile.id == nil do
          id = UUID.uuid4()

          acc_map
          |> Map.put({x, y}, %Tile{tile | id: id, display: "["})
          |> Map.put({x + 1, y}, %Tile{right_tile | id: id, display: "]"})
        else
          acc_map
        end
      else
        acc_map
      end
    end)
  end

  def calculate_box_coordinates(map) do
    map
    |> Enum.filter(fn {_, tile} -> tile.type === :box end)
    |> Enum.group_by(fn {_, tile} -> tile.id end)
    |> Enum.map(fn {_, tiles} ->
      tiles = Enum.sort_by(tiles, fn {_, tile} -> tile.x end)
      [{_, tile} | _tail] = tiles
      {100 * tile.y + tile.x, tile}
    end)
  end

  def perform_moves(map, moves) do
    robot = Enum.find(map, &(elem(&1, 1).type === :robot)) |> elem(1)
    perform_moves(map, moves, robot)
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

      _other ->
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
        boxes_with_id = get_boxes_with_id(map, box_id)

        {can_move, all_boxes} = check_boxes_recursively(map, boxes_with_id, dx, dy, [])

        if can_move do
          new_tiles =
            Enum.reduce(all_boxes, tiles, fn tile, tiles_acc ->
              Map.put(tiles_acc, {tile.x, tile.y}, tile)
            end)

          push_boxes(map, x + dx, y + dy, dx, dy, new_tiles)
        else
          {map, false}
        end

      %Tile{type: :obstacle} ->
        {map, false}

      %Tile{type: :space} ->
        move_boxes(map, tiles, dx, dy)

      nil ->
        move_boxes(map, tiles, dx, dy)
    end
  end

  defp get_boxes_with_id(map, id) do
    Enum.filter(map, fn {_pos, tile} -> tile.id == id end) |> Enum.map(&elem(&1, 1))
  end

  defp check_boxes_recursively(map, boxes, dx, dy, acc_boxes) do
    Enum.reduce_while(boxes, {true, acc_boxes}, fn tile, {_can_move, acc} ->
      next_pos = {tile.x + dx, tile.y + dy}

      case Map.get(map, next_pos) do
        %Tile{type: :obstacle} ->
          {:halt, {false, acc}}

        %Tile{type: :box, id: new_box_id} ->
          if new_box_id not in Enum.map(acc ++ boxes, & &1.id) do
            new_boxes = get_boxes_with_id(map, new_box_id)

            {can_move, updated_acc} =
              check_boxes_recursively(map, new_boxes, dx, dy, acc ++ [tile])

            if can_move, do: {:cont, {true, updated_acc}}, else: {:halt, {false, updated_acc}}
          else
            {:cont, {true, acc ++ [tile]}}
          end

        _ ->
          {:cont, {true, acc ++ [tile]}}
      end
    end)
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
