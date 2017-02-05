defmodule Thermostat do
  @moduledoc """
  Documentation for Thermostat.
  """

  def update_temperature(temperature) do
    Thermostat.Server.update_temperature(temperature)
  end
end
