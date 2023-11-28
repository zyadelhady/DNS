defmodule Dns do
  @moduledoc """
  Documentation for `Dns`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dns.hello()
      :world

  """
  def dig(domain) do
    Zones.start_link()
    FileParser.parse_zone_file()
    Zones.get(domain)
  end
end
