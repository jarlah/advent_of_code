defmodule AOC2024.Day14.Part2.Solution do
  import AOC2024.Day14.Part1.Solution

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day14.Part2.Solution.solution(Input.read_file_to_lines!("input.txt"))
      6243

  """
  def solution(input) do
    robots = input |> parse_robots()

    Stream.iterate(1, &(&1 + 1))
    |> Task.async_stream(
      fn seconds ->
        if rem(seconds, 1000) == 0, do: IO.puts("Generated frame for #{seconds} seconds")

        robots
        |> move_robots(101, 103, seconds)
        |> Enum.map(&elem(&1, 0))
        |> print_grid(101, 103)
      end,
      max_concurrency: :erlang.system_info(:logical_processors_available) |> IO.inspect(),
      timeout: :infinity
    )
    |> Enum.reduce_while({0, []}, fn
      {:ok, grid_string}, {count, acc} ->
        if String.contains?(grid_string, "RRRRRRRR") do
          # Halt processing and keep the matched grid
          {:halt, {count + 1, acc ++ [grid_string]}}
        else
          # Continue processing
          {:cont, {count + 1, acc ++ [grid_string]}}
        end

      {:exit, _reason}, acc ->
        {:cont, acc}
    end)
    |> tap(
      &Enum.each(elem(&1, 1), fn grid ->
        IO.puts(grid)
        :timer.sleep(1)
      end)
    )
    |> elem(0)
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
