defmodule AOC2024.Day13.Part2.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day13.Part2.Solution.solution(Common.read_file_to_lines!("input.txt"))
      77407675412647

  """
  def solution(lines) do
    lines
    |> Util.parse_machines()
    |> Enum.map(fn %{"Prize" => {x, y}} = config ->
      Map.put(config, "Prize", {x + 10_000_000_000_000, y + 10_000_000_000_000})
    end)
    |> Enum.map(fn config ->
      {
        Map.get(config, "Button A"),
        Map.get(config, "Button B"),
        Map.get(config, "Prize")
      }
    end)
    |> Enum.map(&solve_machine/1)
    |> Enum.flat_map(&calculate_cost/1)
    |> Enum.sum()
  end

  @doc ~S"""
  Linear algebra tells us there is at most one solution to this system of equations (that it’s integer division doesn’t play into it).
  We can solve with a simple application of Cramer’s rule or any equivalent method.
  """
  def solve_machine({{aX, aY}, {bX, bY}, {tX, tY}}) do
    x = (bY * tX - bX * tY) / (aX * bY - bX * aY)
    y = (aX * tY - aY * tX) / (aX * bY - bX * aY)

    if floor(x) == x and floor(y) == y do
      [trunc(x), trunc(y)]
    end
  end

  def calculate_cost([a, b]), do: [3 * a + b]
  def calculate_cost(_), do: []
end
