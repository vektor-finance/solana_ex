defmodule SolanaEx.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/vektor-finance/solana_ex"

  def project do
    [
      app: :solana_ex,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SolanaEx.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.0"},
      {:tesla, "~> 1.2"},
      # test/dev dependencies
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: [:test], runtime: false}
    ]
  end

  defp package,
    do: [
      name: "solana_ex",
      maintainers: ["Vektor <engineering@vektor.finance>"],
      files: ["lib", "solana_ex", "mix.exs", "README.md"],
      links: %{"GitHub" => @source_url}
    ]
end
