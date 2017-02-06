defmodule Thermostat.Server do
  @doc """
  Start thermostat server
  """
  def start_link do
    Agent.start_link(fn -> %{target_temperature: Application.get_env(:thermostat, :target_temperature)} end, name: :serial)
  end

  def get(key) do
    Agent.get(:serial, &Map.get(&1, key))
  end

  def put(key, value) do
    Agent.update(:serial, &Map.put(&1, key, value))
  end

  def delete(key) do
    Agent.get_and_update(:serial, &Map.pop(&1, key))
  end
end
