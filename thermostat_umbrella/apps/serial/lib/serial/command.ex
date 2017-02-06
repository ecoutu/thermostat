defmodule Serial.Command do
  @doc ~S"""
  Parses the given `line` into a command.
  ## Examples
      iex> Serial.Command.parse "TEMP 20.96\n"
      {:ok, {:temperature, 20.96}}
  Unknown commands or commands with the wrong number of
  arguments return an error:
      iex> Serial.Command.parse "UNKNOWN shopping eggs\n"
      {:error, :unknown_command}
      iex> Serial.Command.parse "GET shopping\n"
      {:error, :unknown_command}
  """
  def parse(line) do
    case String.split(line) do
      ["TEMP", temperature] -> {:ok, {:temperature, String.to_float temperature}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Runs the given command.
  """
  def run(command)

  def run({:temperature, temperature}) do
    {:ok, Thermostat.update_temperature(temperature)}
  end
end
