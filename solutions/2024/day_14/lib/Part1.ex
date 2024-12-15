defmodule AOC2024.Day14.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day14.Part1.Solution.solution(Input.read_string_to_lines!(\"""
      ...>p=0,4 v=3,-3
      ...>p=6,3 v=-1,-3
      ...>p=10,3 v=-1,2
      ...>p=2,0 v=2,-1
      ...>p=0,0 v=1,3
      ...>p=3,0 v=-2,-2
      ...>p=7,6 v=-1,-3
      ...>p=3,0 v=-1,-2
      ...>p=9,3 v=2,3
      ...>p=7,3 v=-1,2
      ...>p=2,4 v=2,-3
      ...>p=9,5 v=-3,-3
      ...>\"""), 100, 11, 7)
      12

      iex> AOC2024.Day14.Part1.Solution.solution(Input.read_file_to_lines!("input.txt"), 100, 101, 103)
      222901875

  """
  def solution(input, seconds, width, height) do
    input
    |> parse_robots()
    |> move_robots(width, height, seconds)
    |> remove_middle_robots(width, height)
    |> get_quadrants_of_robots(width, height)
    |> calculate_safety_factor()
  end

  def move_robots(robots, _width, _height, 0), do: robots

  def move_robots(robots, width, height, seconds) do
    robots
    |> Enum.map(fn {{x, y}, {dx, dy} = velocity} ->
      new_x = rem(x + dx, width)
      new_y = rem(y + dy, height)

      # Ensure positive positions if rem() results in negative values
      adjusted_x = if new_x < 0, do: new_x + width, else: new_x
      adjusted_y = if new_y < 0, do: new_y + height, else: new_y

      {{adjusted_x, adjusted_y}, velocity}
    end)
    |> move_robots(width, height, seconds - 1)
  end

  def remove_middle_robots(robots, width, height) do
    middle_x = div(width, 2)
    middle_y = div(height, 2)

    # Correct pattern match
    Enum.reject(robots, fn {{x, y}, _velocity} ->
      x == middle_x or y == middle_y
    end)
  end

  def get_quadrants_of_robots(robots, width, height) do
    middle_x = div(width, 2)
    middle_y = div(height, 2)

    Enum.reduce(robots, {[], [], [], []}, fn {{x, y} = pos, _velocity}, {q1, q2, q3, q4} ->
      cond do
        # Top-left
        x < middle_x and y < middle_y -> {[pos | q1], q2, q3, q4}
        # Top-right
        x >= middle_x and y < middle_y -> {q1, [pos | q2], q3, q4}
        # Bottom-left
        x < middle_x and y >= middle_y -> {q1, q2, [pos | q3], q4}
        # Bottom-right
        x >= middle_x and y >= middle_y -> {q1, q2, q3, [pos | q4]}
      end
    end)
    |> Tuple.to_list()
  end

  def calculate_safety_factor(list_of_quadrants) do
    Enum.reduce(
      list_of_quadrants,
      1,
      fn quadrant, acc ->
        factor =
          Enum.group_by(quadrant, & &1)
          |> Map.values()
          |> Enum.map(&length/1)
          |> Enum.sum()

        acc * factor
      end
    )
  end

  def parse_robots(input) do
    input
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn
      [position, velocity] ->
        {
          parse_coords(position),
          parse_coords(velocity)
        }
    end)
  end

  def parse_coords(str) do
    str
    |> String.split("=")
    |> List.last()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
