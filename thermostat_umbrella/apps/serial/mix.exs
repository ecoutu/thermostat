defmodule Serial.Mixfile do
  use Mix.Project

  def project do
    [app: :serial,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger, :nerves_uart],
     mod: {Serial.Application, []}]
  end

  defp deps do
    [{:thermostat, in_umbrella: true},
     {:nerves_uart, "~> 0.1.1"}]
  end
end
