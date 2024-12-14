defmodule Day1.MixProject do
  use Mix.Project

  def project do
    [
      app: :year_2024_day13,
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
      {:common, path: "../../common"}
    ]
  end
end
