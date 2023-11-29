defmodule Structs.DnsHeader do
  @moduledoc """
  DNS Header Structure.

  This module defines a struct representing the header of a DNS message.
  """

  import Bitwise

  @size_id 16
  @size_flags 16
  @size_qdcount 16
  @size_ancount 16
  @size_nscount 16
  @size_arcount 16

  defstruct [
    :id,
    :qr,
    :opcode,
    :aa,
    :tc,
    :rd,
    :ra,
    :z,
    :rcode,
    :qdcount,
    :ancount,
    :nscount,
    :arcount
  ]

  @doc """
  Decodes a binary message into a DNS header struct.

  ## Parameters

  - `message`: Binary representation of a DNS message.

  ## Returns

  A tuple with the decoded DNS header struct and the remaining message.
  """
  def decode_header(message) do
    <<id::size(@size_id), flags::size(@size_flags), qdcount::size(@size_qdcount),
      ancount::size(@size_ancount), nscount::size(@size_nscount),
      arcount::size(@size_arcount)>> = message

    {
      %__MODULE__{
         id: id,
        qr: !!(flags >>> 15),    # QR: Query/Response flag
        opcode: flags >>> 11 &&& 0b1111,  # OPCODE: Operation Code
        aa: !!(flags >>> 10 &&& 0b1),  # AA: Authoritative Answer flag
        tc: !!(flags >>> 9 &&& 0b1),   # TC: TrunCation flag
        rd: !!(flags >>> 8 &&& 0b1),   # RD: Recursion Desired flag
        ra: !!(flags >>> 7 &&& 0b1),   # RA: Recursion Available flag
        z: flags >>> 4 &&& 0b1111,     # Z: Reserved field
        rcode: flags &&& 0b1111,       # RCODE: Response Code
        qdcount: qdcount,               # QDCOUNT: Question Count
        ancount: ancount,               # ANCOUNT: Answer Record Count
        nscount: nscount,               # NSCOUNT: Authority Record Count
        arcount: arcount                # ARCOUNT: Additional Record Count     
      }

    }
  end
end
