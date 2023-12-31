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

  def handle_info({:udp, port, ip, _, data}, socket) do
    handle_packet(data, socket, port, ip)
  end

  defp handle_packet("quit\n", socket, port, ip) do
    IO.puts("Received: quit. Closing down...")
    :gen_udp.close(socket)
    {:stop, :normal, nil}
  end

  # fallback pattern match to handle all other (non-"quit") messages
  defp handle_packet(data, socket, port, ip) do
    # IO.inspect(ip)
    Dns.handle(data)
    # Assuming `socket` is a connected socket
    # response = "hello"

    # Send the response to the socket
    # :gen_udp.send({ip, port}, response)
    {:noreply, socket}
  end
end
