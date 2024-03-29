defmodule PxUAuth0.MixProject do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :pxu_auth0,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PxUAuth0, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dev
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false},
      {:ueberauth_identity, "~> 0.2", only: :dev},
      # Everything else
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:joken, "~> 2.6"},
      {:ueberauth, "~> 0.7"},
      {:ueberauth_auth0, "~> 2.1"}
    ]
  end
end
