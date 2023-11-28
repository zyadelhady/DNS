defmodule FileParser do
  @moduledoc """
  FileParser module for parsing DNS zone files.

  This module provides functions to parse a DNS zone file, filter records based on specified conditions, 
  and construct DNS records using predefined types and classes.

  Example:
    FileParser.parse_zone_file()

  """
  use Agent
  alias Zones
  @rr_types %{A: 1, NS: 2, AAAA: 28}
  @rr_classes %{IN: 1}

  def constants do
    {@rr_types,@rr_classes}
  end


  @spec parse_zone_file() :: [RRRecord.t()]
  def parse_zone_file do
    File.stream!("root.zone.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Enum.filter(&is_valid_server?/1)
    |> Enum.map(&Zones.add/1)
  end

  @spec is_valid_server?([String.t()]) :: boolean()
  defp is_valid_server?([_, _, class, type | _]) do
    Map.has_key?(@rr_classes, String.to_atom(class)) &&
      Map.has_key?(@rr_types, String.to_atom(type))
  end
end
