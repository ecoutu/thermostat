defmodule Thermostat do
  use Application

  def start(_type, _args) do
    Thermostat.Supervisor.start_link
  end
end
