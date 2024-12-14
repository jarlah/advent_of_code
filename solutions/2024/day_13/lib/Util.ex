defmodule Util do
  def parse_machines(lines) do
    lines
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
  end
end
