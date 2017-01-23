defmodule Thermostat.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Thermostat.Registry, [Thermostat.Registry]),
      supervisor(Thermostat.Bucket.Supervisor, [])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
