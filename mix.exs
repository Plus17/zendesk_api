defmodule ZendeskAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :zendesk_api,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      elixirc_options: [warnings_as_errors: true],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      {:mox, "~> 1.0", only: :test},
      {:telemetry, "~> 1.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
