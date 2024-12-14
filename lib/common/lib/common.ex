defmodule Common do
  @moduledoc """
  Documentation for `Common`.
  """

  def read_file_to_lines!(path) do
    path
    |> File.read!()
    |> read_string_to_lines!()
  end

  def read_string_to_lines!(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
