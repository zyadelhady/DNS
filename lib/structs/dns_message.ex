defmodule Structs.DnsMessage do
  defstruct header: %Structs.DnsHeader{},
            question: %Structs.DnsQuestion{},
            resource_records: %Structs.ResourceRecord{}
end
