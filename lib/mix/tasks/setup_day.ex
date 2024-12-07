defmodule Mix.Tasks.SetupDay do
  def run([year_number, day_number]) do
    base_path = Path.absname("lib/#{year_number}/day_#{day_number}/")

    with :ok <- File.mkdir_p(base_path) do
      create_file(base_path, "input.txt", "TBD")
      create_file(base_path, "readme.txt", "# TBD")
      create_file(base_path, "Input.ex", generate_input_module_content(year_number, day_number))
      create_file(base_path, "Part1.ex", generate_part_module_content(year_number, day_number, 1))
      create_file(base_path, "Part2.ex", generate_part_module_content(year_number, day_number, 2))
    end
  end

  defp create_file(base_path, filename, content) do
    file_path = Path.join(base_path, filename)

    if !File.exists?(file_path) do
      File.write(file_path, content)
      IO.puts("Created file: #{file_path}")
    else
      IO.puts("File exists: #{file_path}. Skipping.")
    end
  end

  defp generate_input_module_content(year_number, day_number) do
    """
    defmodule AOC#{year_number}.Day#{day_number}.Input do
      def input do
        File.read!(Path.join(__DIR__, "input.txt"))
        |> String.split("\\n")
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))
      end
    end
    """
  end

  defp generate_part_module_content(year_number, day_number, part_number) do
    """
    defmodule AOC#{year_number}.Day#{day_number}.Part#{part_number}.Solution do
      @doc ~S\"\"\"
      ## Examples

          iex> AOC#{year_number}.Day#{day_number}.Part#{part_number}.Solution.solution(AOC#{year_number}.Day#{day_number}.Input.input())
          0

      \"\"\"
      def solution(_input), do: 0
    end
    """
  end
end
