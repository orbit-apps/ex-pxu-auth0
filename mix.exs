defmodule PxUAuth0.MixProject do
  use Mix.Project

  def project do
    [
      app: :pxu_auth0,
      version: "0.1.6",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
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
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ueberauth_identity, "~> 0.2", only: :dev},
      # Everything else
      {:joken, "~> 2.0"},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_auth0, "~> 0.3"},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"}
    ]
  end
end
