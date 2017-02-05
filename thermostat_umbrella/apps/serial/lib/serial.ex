defmodule Serial do
  require Logger

  def connect(device, speed) do
    {:ok, pid} = Nerves.UART.start_link
    Nerves.UART.open(pid, device, speed: speed, active: false, framing: {Nerves.UART.Framing.Line, separator: "\r\n"})
    Logger.info "Accepting connections on device #{device}"
    serve(pid)
  end

#  defp loop_acceptor(socket) do
#    {:ok, client} = :gen_tcp.accept(socket)
#    {:ok, pid} = Task.Supervisor.start_child(SerialServer.TaskSupervisor, fn -> serve(client) end)
#    :ok = :gen_tcp.controlling_process(client, pid)
#    loop_acceptor(socket)
#  end

  defp serve(pid) do
    msg =
      with {:ok, data} <- read_line(pid),
           {:ok, command} <- Serial.Command.parse(data),
           do: Serial.Command.run(command)

#    case msg do
#      {:ok, result} ->
#        Logger.info "OK! Result: #{result}"
#      {:error, result} ->
#        Logger.error "OH NOES! Result: #{result}"
#    end

    serve(pid)
  end

  defp read_line(pid) do
    Nerves.UART.read(pid, 60000)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    # Known error. Write to the client.
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    # The connection was closed, exit politely.
    exit(:shutdown)
  end

  defp write_line(socket, {:error, :not_found}) do
    :gen_tcp.send(socket, "NOT FOUND\r\n")
  end

  defp write_line(socket, {:error, error}) do
    # Unknown error. Write to the client and exit.
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
