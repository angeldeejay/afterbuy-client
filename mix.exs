defmodule Afterbuy.MixProject do
  use Mix.Project

  defp description do
    """
    Afterbuy API Client for Elixir
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "CHANGELOG*"],
      maintainers: ["Andrés Vanegas"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/angeldeejay/afterbuy-client"}
    ]
  end

  def project do
    [
      app: :afterbuy,
      version: "1.0.6",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/utils", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [
        :logger,
        :httpoison
      ]
    ]
  end

  defp deps do
    [
      {:erlsom, "~> 1.5"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:httpoison, "~> 1.6"},
      {:inflex, "~> 2.0"},
      {:saxy, "~> 1.1"},
      {:tesla, "~> 1.3.0"},
      {:timex, "~> 3.5"}
    ]
  end
end
