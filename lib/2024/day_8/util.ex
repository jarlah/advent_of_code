defmodule AOC2024.Day8.Utils do
  defguard is_alphanumeric(col) when col in ?0..?9 or col in ?a..?z or col in ?A..?Z
end
