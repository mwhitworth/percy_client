defmodule PercyClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :percy_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [ci: :test],
      deps: deps(),
      description: "A Percy client for Elixir",
      package: package(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.4"},
      {:tesla_extra, "~> 0.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:tesla, "~> 1.4"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:wallaby, "~> 0.30", runtime: false}
    ]
  end

  def package do
    [
      files: ["lib", "mix.exs", "README.md"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mwhitworth/percy_client"}
    ]
  end

  defp aliases do
    [
      ci: [
        "format --check-formatted",
        "cmd percy exec --verbose  -- mix test"
      ]
    ]
  end
end
