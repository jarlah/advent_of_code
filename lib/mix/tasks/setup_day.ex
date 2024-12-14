defmodule Mix.Tasks.SetupDay do
  def run([year_number, day_number]) do
    base_path = Path.absname("lib/#{year_number}/day_#{day_number}/")

    with lib_path = Path.join(base_path, "lib"),
         :ok <- File.mkdir_p(lib_path),
         test_path = Path.join(base_path, "test"),
         :ok <- File.mkdir_p(test_path) do
      create_file(base_path, "mix.exs", generate_mix_file(year_number, day_number))
      create_file(base_path, ".formatter.exs", generate_formatter_file())
      create_file(lib_path, "Input.ex", generate_input_module_content(year_number, day_number))
      create_file(lib_path, "Part1.ex", generate_part_module_content(year_number, day_number, 1))
      create_file(lib_path, "Part2.ex", generate_part_module_content(year_number, day_number, 2))
      create_file(test_path, "doc_test.exs", generate_doc_test_content(year_number, day_number))
      create_file(test_path, "test_helper.exs", generate_test_helper_content())
    end
  end

  defp generate_doc_test_content(year_number, day_number) do
    """
    defmodule AOC#{year_number}.Day#{day_number}.DocTest do
      use ExUnit.Case

      doctest AOC#{year_number}.Day#{day_number}.Part1.Solution
      doctest AOC#{year_number}.Day#{day_number}.Part2.Solution
    end
    """
  end

  defp generate_test_helper_content() do
    """
    ExUnit.start()
    """
  end

  defp generate_mix_file(year_number, day_number) do
    """
    defmodule AOC#{year_number}.Day#{day_number}.MixProject do
      use Mix.Project

      def project do
        [
          app: :year_#{year_number}_day#{day_number},
          version: "0.1.0",
          elixir: "~> 1.17",
          start_permanent: Mix.env() == :prod,
          deps: deps()
        ]
      end

      def application do
        [
          extra_applications: [:logger]
        ]
      end

      defp deps do
        [
          {:common, path: "../../common"},
          {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
        ]
      end
    end
    """
  end

  defp generate_formatter_file() do
    """
    # Used by "mix format"
    [
      inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
    ]
    """
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
