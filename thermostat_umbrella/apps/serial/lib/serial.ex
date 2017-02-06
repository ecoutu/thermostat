defmodule Serial do
  require Logger

  def connect(device, speed) do
    {:ok, pid} = Nerves.UART.start_link
    Nerves.UART.open(pid, device, speed: speed, active: false, framing: {Nerves.UART.Framing.Line, separator: "\n"})
    Logger.info "Accepting connections on device #{device}"
    serve(pid)
  end

  defp serve(pid) do
    msg =
      with {:ok, data} <- read_line(pid),
           {:ok, command} <- Serial.Command.parse(data),
           do: Serial.Command.run(command)

    write_line(pid, msg)
    serve(pid)
  end

  defp read_line(pid) do
    Nerves.UART.read(pid, 60000)
  end

  defp write_line(pid, {:ok, text}) do
    Nerves.UART.write(pid, text)
  end

  defp write_line(pid, {:error, :unknown_command}) do
    Nerves.UART.write(pid, "UNKNOWN")
  end
end
