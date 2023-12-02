defmodule Dns do
  @moduledoc """
  Documentation for `Dns`.
  """
  alias Structs.DnsQuestion
  alias Structs.DnsHeader
  require Logger

  @doc """
  Hello world.

  ## Examples

      iex> Dns.hello()
      :world

  """
  def handle(message) do
    # first_16_bits = :binary.part(message, 0, 16)
    all =
      message
      |> DnsHeader.decode_header()
      |> DnsQuestion.decode_question()

    IO.inspect(all)
    # IO.inspect(rest)
  end
end
