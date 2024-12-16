defmodule AOC2024.Day15.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day15.Part1.Solution.solution(Input.read_string_to_lines!(\"""
      ...>########
      ...>#..O.O.#
      ...>##@.O..#
      ...>#...O..#
      ...>#.#.O..#
      ...>#...O..#
      ...>#......#
      ...>########
      ...>
      ...><^^>>>vv<v>>v<<
      ...>\"""))
      2028
      iex> AOC2024.Day15.Part1.Solution.solution(Input.read_string_to_lines!(\"""
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
      ...>
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
      10092
      iex> AOC2024.Day15.Part1.Solution.solution(Input.read_file_to_lines!("input.txt"))
      1415498

  """
  def solution(input) do
    map = get_map(input)
    map |> Map.values() |> Tile.print_tile_map()
    moves = get_moves(input)
    map = perform_moves(map, moves)
    map |> Map.values() |> Tile.print_tile_map()
    calculate_box_coordinates(map) |> Enum.map(&elem(&1, 0)) |> Enum.sum()
  end

  def get_map(input) do
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
              "@" -> [%Tile{x: x, y: y, type: :robot, display: "@"}]
              "#" -> [%Tile{x: x, y: y, type: :obstacle, display: "#"}]
              "O" -> [%Tile{x: x, y: y, type: :box, display: "O"}]
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

  def get_moves(input) do
    input
    |> Enum.filter(&(not String.starts_with?(&1, "#")))
    |> Enum.reduce([], fn line, moves_acc ->
      moves =
        line
        |> String.to_charlist()
        |> Enum.map(&<<&1>>)
        |> Enum.reduce([], fn move, moves_acc ->
          [
            case move do
              ">" -> :right
              "<" -> :left
              "^" -> :up
              "v" -> :down
            end
          ] ++ moves_acc
        end)

      moves ++ moves_acc
    end)
    |> Enum.reverse()
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

    case Map.get(map, {next_robot.x, next_robot.y}) do
      %Tile{type: :box} ->
        # lets try to push the robot and the boxes in front of it
        {updated_map, can_move} = push_boxes(map, robot_x, robot_y, dx, dy)

        if can_move do
          perform_moves(updated_map, rest_moves, next_robot)
        else
          perform_moves(map, rest_moves, robot)
        end

      %Tile{type: :obstacle} ->
        # do nothing, continue
        perform_moves(map, rest_moves, robot)

      _ ->
        # there are no box or no obstacle, just move the robot
        perform_moves(
          map
          |> Map.put({next_robot.x, next_robot.y}, next_robot)
          |> Map.delete({robot_x, robot_y}),
          rest_moves,
          next_robot
        )
    end
  end

  def push_boxes(map, robot_x, robot_y, dx, dy) do
    push_boxes(map, robot_x + dx, robot_y + dy, dx, dy, [{robot_x, robot_y}])
  end

  def push_boxes(map, x, y, dx, dy, positions) do
    case Map.get(map, {x, y}) do
      %Tile{type: :box} ->
        push_boxes(map, x + dx, y + dy, dx, dy, [{x, y} | positions])

      %Tile{type: :obstacle} ->
        {map, false}

      %Tile{type: :space} ->
        move_boxes(map, positions |> Enum.map(&Map.get(map, &1)), dx, dy)

      nil ->
        move_boxes(map, positions |> Enum.map(&Map.get(map, &1)), dx, dy)
    end
  end

  def move_boxes(map, positions, dx, dy) do
    Enum.reduce(positions, {map, true}, fn %Tile{x: x, y: y} = tile, {acc_map, _} ->
      new_tile_position = {x + dx, y + dy}

      acc_map =
        acc_map
        |> Map.put(
          new_tile_position,
          Tile.move(tile, dx, dy)
        )
        |> Map.delete({x, y})

      {acc_map, true}
    end)
  end

  def calculate_box_coordinates(map) do
    map
    |> Map.filter(fn {_, tile} -> tile.type === :box end)
    |> Enum.map(fn {_, tile} ->
      {100 * tile.y + tile.x, tile}
    end)
  end
end
