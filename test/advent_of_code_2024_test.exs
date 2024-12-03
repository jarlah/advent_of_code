defmodule AdventOfCode2024Test do
  use ExUnit.Case
  doctest AdventOfCode2024.Day1.Input
  doctest AdventOfCode2024.Day1.Part1.Solution
  doctest AdventOfCode2024.Day1.Part2.Solution
  doctest AdventOfCode2024.Day2.Input
  doctest AdventOfCode2024.Day2.Part1.Solution
  doctest AdventOfCode2024.Day2.Part2.Solution
  doctest AdventOfCode2024.Day3.Input
  doctest AdventOfCode2024.Day3.Part1.Solution
  doctest AdventOfCode2024.Day3.Part2.Solution
  # doctest AdventOfCode2024.Day4.Input
  # doctest AdventOfCode2024.Day4.Part1.Solution
  # doctest AdventOfCode2024.Day4.Part2.Solution
  # doctest AdventOfCode2024.Day5.Input
  # doctest AdventOfCode2024.Day5.Part1.Solution
  # doctest AdventOfCode2024.Day5.Part2.Solution
  # doctest AdventOfCode2024.Day6.Input
  # doctest AdventOfCode2024.Day6.Part1.Solution
  # doctest AdventOfCode2024.Day6.Part2.Solution

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
