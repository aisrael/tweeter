defmodule Tweeter.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [{:distillery, "~> 2.0"}]
  end

  # Let's us run `mix ecto.setup` in the umbrella root but will run
  # `mix ecto.setup` in all the child apps
  defp aliases do
    [
      "ecto.setup": [
        "cmd mix ecto.setup"
      ]
    ]
  end
end
