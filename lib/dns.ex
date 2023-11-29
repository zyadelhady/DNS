defmodule Dns do
  @moduledoc """
  Documentation for `Dns`.
  """
  require Logger

  @doc """
  Hello world.

  ## Examples

      iex> Dns.hello()
      :world

  """
  def handle(message) do
    # first_16_bits = :binary.part(message, 0, 16)
    extract_header(message)
    # IO.inspect(first_16_bits)
    IO.inspect(message)
  end

  def extract_header(message) do
    # :binary.part(message,0,16)
    <<id::size(16), qr::size(1), op_code::size(4), aa::size(1), tc::size(1), rd::size(1),
      ra::size(1), z::size(3), rcode::size(4), qdcount::size(16), ancount::size(16),
      nscount::size(16), arcount::size(16), rest::binary>> = message

    IO.inspect(op_code)
  end
end
