defmodule Thermostat do
  @moduledoc """
  Documentation for Thermostat.
  """

  def update_temperature(temperature) do
    Thermostat.Server.put(:temperature, temperature)
    if temperature > Thermostat.Server.get(:target_temperature) do
      "RELAY OFF"
    else
      "RELAY ON"
    end
  end

  def set_target_temperature(temperature) do
    Thermostat.Server.put(:target_temperature, temperature)
  end
end
