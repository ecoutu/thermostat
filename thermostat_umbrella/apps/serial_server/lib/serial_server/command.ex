defmodule SerialServer.Command do
  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> SerialServer.Command.parse "TEMP 20.96\r\n"
      {:ok, {:temperature, 20.96}}

  Unknown commands or commands with the wrong number of
  arguments return an error:

      iex> SerialServer.Command.parse "UNKNOWN shopping eggs\r\n"
      {:error, :unknown_command}

      iex> SerialServer.Command.parse "GET shopping\r\n"
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
    Thermostat.Registry.create(Thermostat.Registry, bucket)
    {:ok, "OK\r\n"}
  end

#  def run({:create, bucket}) do
#    Thermostat.Registry.create(Thermostat.Registry, bucket)
#    {:ok, "OK\r\n"}
#  end
#
#  def run({:get, bucket, key}) do
#    lookup bucket, fn pid ->
#      value = Thermostat.Bucket.get(pid, key)
#      {:ok, "#{value}\r\nOK\r\n"}
#    end
#  end
#
#  def run({:put, bucket, key, value}) do
#    lookup bucket, fn pid ->
#      Thermostat.Bucket.put(pid, key, value)
#      {:ok, "OK\r\n"}
#    end
#  end
#
#  def run({:delete, bucket, key}) do
#    lookup bucket, fn pid ->
#      Thermostat.Bucket.delete(pid, key)
#      {:ok, "OK\r\n"}
#    end
#  end
#
#  defp lookup(bucket, callback) do
#    case Thermostat.Registry.lookup(Thermostat.Registry, bucket) do
#      {:ok, pid} -> callback.(pid)
#      :error -> {:error, :not_found}
#    end
#  end
end
