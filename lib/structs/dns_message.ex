defmodule Structs.DnsMessage do
  defstruct header: %Structs.DnsHeader{},
            question: %Structs.DnsQuestion{},
            answers: [%Structs.ResourceRecord{}],
            authority: [%Structs.ResourceRecord{}],
            additional: [%Structs.ResourceRecord{}]
end
