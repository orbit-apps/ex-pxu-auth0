defmodule PxUAuth0 do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: PxUAuth0.Worker.start_link(arg)
      # {PxUAuth0.Worker, arg}
      PxUAuth0.AccessToken
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExAuth0Client.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
