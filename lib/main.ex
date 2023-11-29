defmodule Main do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {UdpServer, 3535},
      Structs.Zones
    ]

    opts = [strategy: :one_for_one]
    {:ok, pid} = Supervisor.start_link(children, opts)
    FileParser.parse_zone_file()
    {:ok, pid}
  end
end
