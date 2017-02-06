defmodule Thermostat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Thermostat.Server, []),
    ]

    opts = [strategy: :one_for_one, name: Thermostat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
