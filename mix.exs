defmodule CFM.Mixfile do
  use Mix.Project

  def project do
    [app: :cfm,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [ 
      mod: {CFM.App, []},
      applications: [:logger, :httpoison, :ecto]
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
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:hulaaki, "~> 0.0.2"}, #mqtt client
      {:poison, "~> 2.0"}, #json parser
      {:httpoison, "~> 0.8.0"}, #http client
      {:cauldron, "~> 0.1.5"}, #http server
      {:mariaex, "~> 0.7.3"}, #mysql driver
      {:ecto, "~> 2.0.0-beta"}, #db orm
      {:redix, "~> 0.3.6"} #redix client
    ]
  end
end