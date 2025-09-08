defmodule PhoenixWebConsole.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_web_console,
      version: "0.1.0",
      elixir: "~> 1.14",
      description: "Easy Phoenix web console logging installer using Igniter",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package do
    [
      maintainers: ["Your Name"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/yourusername/phoenix_web_console"
      },
      files: ~w(lib priv mix.exs README.md LICENSE CHANGELOG.md)
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
      {:igniter, "~> 0.3", optional: true},
      {:phoenix_live_reload, "~> 1.5", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
