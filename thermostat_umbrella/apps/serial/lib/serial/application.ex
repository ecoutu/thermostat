defmodule Serial.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Task, [Serial, :connect, ["ttyACM0", 9600]])
    ]

    opts = [strategy: :one_for_one, name: Serial.Supervisor]
    Supervisor.start_link(children, opts)
  end
end