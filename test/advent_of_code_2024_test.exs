defmodule AdventOfCode2024Test do
  use ExUnit.Case

  days = 1..25
  modules = ["Input", "Part1.Solution", "Part2.Solution"]

  for day <- days, module <- modules do
    doctest_module = :"Elixir.AdventOfCode2024.Day#{day}.#{module}"
    if Code.ensure_loaded?(doctest_module) do
      doctest doctest_module
    end
  end

  describe "day1" do
    alias AdventOfCode2024.Day1
    import Day1.Input, only: [test_input: 0]

    test "part1" do
      assert Day1.Part1.Solution.solution(test_input()) == 11
    end

    test "part2" do
      assert Day1.Part2.Solution.solution(test_input()) == 31
    end
  end

  describe "day2" do
    alias AdventOfCode2024.Day2
    import Day2.Input, only: [test_input: 0]

    test "part1" do
      assert Day2.Part1.Solution.solution(test_input()) == 2
    end

    test "part2" do
      assert Day2.Part2.Solution.solution(test_input()) == 4
    end
  end

  describe "day3" do
    alias AdventOfCode2024.Day3
    import Day3.Input, only: [test_input: 0, test_input_dodont: 0]

    test "part1" do
      assert Day3.Part1.Solution.solution(test_input()) == 161
    end

    test "part2" do
      assert Day3.Part2.Solution.solution(test_input_dodont()) == 48
    end
  end
end
