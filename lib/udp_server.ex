defmodule UdpServer do
  use GenServer

  def start_link(port \\ 3535) do
    GenServer.start_link(__MODULE__, port)
    |> IO.inspect(label: ~c"start_link/1")
  end

  def init(port) do
    :gen_udp.open(port, [:binary, active: true])
    |> IO.inspect(label: ~c"init/0")
  end

  def handle_info({:udp, _, _, _, data}, socket) do
    handle_packet(data, socket)
  end

  defp handle_packet("quit\n", socket) do
    IO.puts("Received: quit. Closing down...")
    :gen_udp.close(socket)
    {:stop, :normal, nil}
  end

  # fallback pattern match to handle all other (non-"quit") messages
  defp handle_packet(data, socket) do
    IO.inspect(data)
    {:noreply, socket}
  end
end
