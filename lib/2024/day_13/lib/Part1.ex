defmodule AOC2024.Day13.Part1.Solution do
  @doc ~S"""
  ## Examples

      iex> AOC2024.Day13.Part1.Solution.solution(Common.read_string_to_lines!("""
      ...>Button A: X+94, Y+34
      ...>Button B: X+22, Y+67
      ...>Prize: X=8400, Y=5400
      ...>
      ...>Button A: X+26, Y+66
      ...>Button B: X+67, Y+21
      ...>Prize: X=12748, Y=12176
      ...>
      ...>Button A: X+17, Y+86
      ...>Button B: X+84, Y+37
      ...>Prize: X=7870, Y=6450
      ...>
      ...>Button A: X+69, Y+23
      ...>Button B: X+27, Y+71
      ...>Prize: X=18641, Y=10279
      ...>
      ...>"""))
      480
      iex> AOC2024.Day13.Part1.Solution.solution(Common.read_file_to_lines!("input.txt"))
      37901

  """
  def solution(input) do
    input
    |> Enum.chunk_every(3, 3)
    |> Enum.map(fn list ->
      Enum.map(list, &String.split(&1, ":"))
    end)
    |> Enum.map(fn list ->
      Enum.map(list, fn [key, value] ->
        {
          key,
          value
          |> String.split(", ")
          |> Enum.map(&String.trim/1)
          |> Enum.map(&String.split(&1, ~r/[+=]/))
          |> Enum.map(fn [xOrY, pressesOrPositions] ->
            {xOrY, String.to_integer(pressesOrPositions)}
          end)
          |> Enum.reduce(fn {"Y", x}, {"X", y} -> {x, y} end)
        }
      end)
      |> Enum.into(%{})
    end)
    |> Enum.map(&try_to_win_prize/1)
    |> Enum.map(fn
      {:you_won, {_pa, _pb, cost}} -> cost
      {:no_prize, _} -> 0
    end)
    |> Enum.sum()
  end

  defp try_to_win_prize(machine) do
    %{
      "Button A" => {x_inc_a, y_inc_a},
      "Button B" => {x_inc_b, y_inc_b},
      "Prize" => {target_x, target_y}
    } = machine

    # {presses_a, presses_b, total_cost}
    initial_state = {0, 0, 0}
    queue = [initial_state]
    visited = MapSet.new()

    search_for_prize(
      queue,
      visited,
      {x_inc_a, y_inc_a},
      {x_inc_b, y_inc_b},
      {target_x, target_y}
    )
  end

  defp search_for_prize(queue, visited, button_a, button_b, target, max_state \\ {0, 0, 0}) do
    case queue do
      [] ->
        {:no_prize, max_state}

      [current_state | remaining_queue] ->
        if reached_target?(current_state, button_a, button_b, target) do
          {:you_won, current_state}
        else
          {new_queue, new_visited} = try_next_buttons(current_state, remaining_queue, visited)
          new_max_state = update_max_state(max_state, current_state)
          search_for_prize(new_queue, new_visited, button_a, button_b, target, new_max_state)
        end
    end
  end

  defp update_max_state(
         {_max_a, _max_b, max_cost} = max_state,
         {current_a, current_b, current_cost}
       ) do
    if current_cost > max_cost do
      {current_a, current_b, current_cost}
    else
      max_state
    end
  end

  defp reached_target?(
         {presses_a, presses_b, _},
         {x_inc_a, y_inc_a},
         {x_inc_b, y_inc_b},
         {target_x, target_y}
       ) do
    current_x = presses_a * x_inc_a + presses_b * x_inc_b
    current_y = presses_a * y_inc_a + presses_b * y_inc_b
    current_x === target_x and current_y === target_y
  end

  defp try_next_buttons({presses_a, presses_b, cost}, queue, visited) do
    next_states =
      []
      |> add_valid_press(:a, presses_a, presses_b, cost)
      |> add_valid_press(:b, presses_a, presses_b, cost)

    Enum.reduce(
      next_states,
      {queue, visited},
      fn {pa, pb, _cost} = state, {acc_queue, acc_visited} ->
        if MapSet.member?(acc_visited, {pa, pb}) do
          {acc_queue, acc_visited}
        else
          {acc_queue ++ [state], MapSet.put(acc_visited, {pa, pb})}
        end
      end
    )
  end

  defp add_valid_press(list, :a, presses_a, presses_b, cost) when presses_a < 100 do
    [{presses_a + 1, presses_b, cost + 3} | list]
  end

  defp add_valid_press(list, :b, presses_a, presses_b, cost) when presses_b < 100 do
    [{presses_a, presses_b + 1, cost + 1} | list]
  end

  defp add_valid_press(list, _, _, _, _), do: list
end
