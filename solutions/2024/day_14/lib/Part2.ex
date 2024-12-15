defmodule AOC2024.Day14.Part2.Solution do
  import AOC2024.Day14.Part1.Solution

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day14.Part2.Solution.solution(Common.read_file_to_lines!("input.txt"))
      0

  """
  def solution(input) do
    robots =
      input
      |> parse_robots()

    for seconds <- Stream.iterate(1, &(&1 + 2)) do
      robots = move_robots(robots, 101, 103, seconds)

      grid_string =
        robots
        |> Enum.map(&elem(&1, 0))
        |> print_grid(101, 103)

      if String.contains?(grid_string, "RRRRRRRR") do
        IO.puts(grid_string)
        IO.puts("Found a match at #{seconds} seconds")
        exit("found grid")
      end
    end
  end

  defp print_grid(robots, cols, rows) do
    positions = robots |> MapSet.new()

    for y <- 0..(rows - 1), into: "" do
      for x <- 0..(cols - 1), into: "" do
        if MapSet.member?(positions, {x, y}), do: "R", else: "."
      end <>
        "\n"
    end <>
      "\n"
  end
end
