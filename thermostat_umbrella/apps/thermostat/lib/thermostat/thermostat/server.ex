defmodule Thermostat.Server do
  @doc """
  Start serial channel server
  """
  def start_link do
    Agent.start_link(fn -> %{} end, name: :serial)
  end

  @doc """
  Get value from `key`
  """
  def get(key) do
    Agent.get(:serial, &Map.get(&1, key))
  end

  @doc """
  Set `key` equal to `value`
  """
  def put(key, value) do
    Agent.update(:serial, &Map.put(&1, key, value))
  end

  @doc """
  Deletes `key` from server.

  Returns the current value of `key`, if `key` exists.
  """
  def delete(key) do
    Agent.get_and_update(:serial, &Map.pop(&1, key))
  end

  def update_temperature(temperature) do
    Agent.update(:serial, &Map.put(&1, :temperature, temperature))
  end
end
