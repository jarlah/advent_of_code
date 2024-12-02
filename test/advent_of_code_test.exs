defmodule AdventOfCodeTest do
  use ExUnit.Case, async: true

  @moduletag timeout: :infinity

  years = 2015..2080
  days = 1..25
  parts = 1..2

  for year <- years, day <- days, part <- parts do
    doctest_module = :"Elixir.AOC#{year}.Day#{day}.Part#{part}.Solution"

    if Code.ensure_loaded?(doctest_module) do
      @tag day: "#{year}.d#{day}.p#{part}"
      doctest doctest_module
    end
  end
end
