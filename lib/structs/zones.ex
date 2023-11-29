defmodule Structs.Zones do
  @moduledoc """
    This module provides functionality for managing DNS zones and their associated records using an Agent.

    ## Usage
    1. Start the Agent using `Zones.start_link/0`.
    2. Add records to the zones using `Zones.add/5`.
    3. Retrieve information about all zones or a specific zone using `Zones.get_all/0` or `Zones.get/1`, respectively.

    ## Example
    ```elixir
    Zones.start_link()
    Zones.add(["example.com", 3600, "IN", "A", "192.168.1.1"])
    Zones.add(["example.com", 3600, "IN", "A", "192.168.1.2"])
    Zones.add(["example.org", 3600, "IN", "A", "192.168.2.1"])

    Zones.get_all()
    # Output: %{"example.com" => %Zones.Structs.ZoneRecord{domain: "example.com", RRs: [%Zones.Structs.RRRecord{address: "192.168.1.2", class: "IN", name: "example.com", ttl: 3600, type: "A"}, %Zones.Structs.RRRecord{address: "192.168.1.1", class: "IN", name: "example.com", ttl: 3600, type: "A"}]}, "example.org" => %Zones.Structs.ZoneRecord{domain: "example.org", RRs: [%Zones.Structs.RRRecord{address: "192.168.2.1", class: "IN", name: "example.org", ttl: 3600, type: "A"}]}}

    Zones.get("example.com")
    # Output: %Zones.Structs.ZoneRecord{domain: "example.com", RRs: [%Zones.Structs.RRRecord{address: "192.168.1.2", class: "IN", name: "example.com", ttl: 3600, type: "A"}, %Zones.Structs.RRRecord{address: "192.168.1.1", class: "IN", name: "example.com", ttl: 3600, type: "A"}]}
  """
  use Agent

  @doc """
  Starts the Zones Agent.

  Returns:

  {:ok, pid}: The Agent process identifier.
  {:error, any}: An error tuple if Agent start fails.
  """
  @spec start_link([]) :: {:ok, pid} | {:error, any}
  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Adds a DNS record to the specified zone.

  Parameters:

  name: The domain name.
  ttl: Time to live for the record.
  class: The record class.
  type: The record type.
  address: The record address.
  Returns:

  :ok: If the record is added successfully.
  """
  @spec add(list()) :: :ok
  def add([name, ttl, class, type, address]) do
    {types, classes} = FileParser.constants()

    Agent.update(__MODULE__, fn zones ->
      case Map.get(zones, name) do
        nil ->
          Map.put(zones, name, %Structs.ZoneRecord{
            domain: name,
            RRs: [
              %Structs.RRRecord{
                name: name,
                type: types[String.to_atom(type)],
                ttl: ttl,
                class: classes[String.to_atom(class)],
                address: address
              }
            ]
          })

        %Structs.ZoneRecord{domain: _, RRs: existing_rrs} = record ->
          updated_record = %Structs.ZoneRecord{
            record
            | RRs: [
                %Structs.RRRecord{
                  name: name,
                  type: types[String.to_atom(type)],
                  ttl: ttl,
                  class: classes[String.to_atom(class)],
                  address: address
                }
                | existing_rrs
              ]
          }

          Map.put(zones, name, updated_record)
      end
    end)
  end

  @doc """
  Retrieves information about all DNS zones and their records.

  Returns:

  A map where keys are domain names and values are Structs.ZoneRecord structs.
  """
  # @spec get_all() :: %{String.t() => Structs.ZoneRecord.t()}
  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Retrieves information about a specific DNS zone.

  Parameters:

  key: The domain name.
  Returns:

  A Structs.ZoneRecord struct for the specified domain, or nil if the domain is not found.
  """
  @spec get(String.t()) :: Structs.ZoneRecord.t() | nil
  def get(key) do
    Agent.get(__MODULE__, fn zones -> Map.get(zones, key) end)
  end
end
