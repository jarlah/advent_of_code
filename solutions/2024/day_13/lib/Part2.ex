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
      [
        Map.get(config, "Button A") |> Tuple.to_list(),
        Map.get(config, "Button B") |> Tuple.to_list(),
        Map.get(config, "Prize") |> Tuple.to_list()
      ]
    end)
    |> Enum.map(&solve_machine/1)
    |> Enum.flat_map(&calculate_cost/1)
    |> Enum.sum()
  end

  def solve_machine([[a, c], [b, d], [e, f]]) do
    x = (d * e - b * f) / (a * d - b * c)
    y = (a * f - c * e) / (a * d - b * c)

    if floor(x) == x and floor(y) == y do
      [trunc(x), trunc(y)]
    end
  end

  def calculate_cost([a, b]), do: [3 * a + b]
  def calculate_cost(_), do: []
end
