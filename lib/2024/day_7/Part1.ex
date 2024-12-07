defmodule AOC2024.Day7.Part1.Solution do
  import AOC2024.Day7.OperatorPermutations

  @doc ~S"""
  ## Examples

      iex> AOC2024.Day7.Part1.Solution.solution(AOC2024.Day7.Input.input())
      945512582195

      iex> AOC2024.Day7.Part1.Solution.solution(AOC2024.Day7.Input.test_input())
      3749
  """
  def solution(input) do
    # total = length(input)
    # {:ok, agent} = Agent.start_link(fn -> %{total: total, processed: 0} end)

    input
    |> Stream.map(&String.split(&1, ":"))
    |> Stream.map(fn [result_str, numbers_str] ->
      {
        result_str
        |> String.to_integer(),
        numbers_str
        |> String.trim()
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      }
    end)
    |> Task.async_stream(
      fn {result, numbers} ->
        solved = solve(numbers) |> Enum.find(fn solved -> solved == result end)

        # processed =
        #   Agent.get_and_update(agent, fn state ->
        #     new_state = %{state | processed: state.processed + 1}
        #     {new_state.processed, new_state}
        #   end)

        # IO.puts("Progress: #{processed}/#{total} (#{Float.round(processed / total * 100, 2)}%)")
        {result, solved == result}
      end,
      max_concurrency: 50,
      timeout: :infinity,
      ordered: false
    )
    |> Stream.filter(fn {:ok, {_, valid}} -> valid end)
    |> Stream.map(fn {:ok, {result, _}} -> result end)
    |> Enum.sum()
  end
end
