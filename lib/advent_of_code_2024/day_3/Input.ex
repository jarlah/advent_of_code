defmodule AdventOfCode2024.Day3.Input do
  def fake do
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  end

  def input do
    File.read!(Path.join(__DIR__, "input.txt"))
  end
end
