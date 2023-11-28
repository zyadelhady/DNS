defmodule Main do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {UdpServer, 3535}
    ]

    opts = [strategy: :one_for_one, name: UdpServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
