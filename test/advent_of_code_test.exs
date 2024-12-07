defmodule AdventOfCodeTest do
  use ExUnit.Case

  @moduletag timeout: :infinity

  years = 2024..2080
  days = 1..25
  modules = ["Input", "Part1.Solution", "Part2.Solution"]

  for year <- years, day <- days, module <- modules do
    doctest_module = :"Elixir.AOC#{year}.Day#{day}.#{module}"

    if Code.ensure_loaded?(doctest_module) do
      @tag day: "#{year}/#{day}"
      doctest doctest_module
    end
  end
end
