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
    <<id::size(@size_id)-integer, flags::size(@size_flags), qdcount::size(@size_qdcount),
      ancount::size(@size_ancount), nscount::size(@size_nscount), arcount::size(@size_arcount),
      rest::binary>> = message

    {
      %__MODULE__{
        id: id,
        # QR: Query/Response flag
        qr: flags >>> 15 == 1,
        # OPCODE: Operation Code
        opcode: flags >>> 11 &&& 0b1111,
        # AA: Authoritative Answer flag
        aa: (flags >>> 10 &&& 0b1) == 1,
        # TC: TrunCation flag
        tc: (flags >>> 9 &&& 0b1) == 1,
        # RD: Recursion Desired flag
        rd: (flags >>> 8 &&& 0b1) == 1,
        # RA: Recursion Available flag
        ra: (flags >>> 7 &&& 0b1) == 1,
        # Z: Reserved field
        z: flags >>> 4 &&& 0b111,
        # RCODE: Response Code
        rcode: flags &&& 0b1111,
        # QDCOUNT: Question Count
        qdcount: qdcount,
        # ANCOUNT: Answer Record Count
        ancount: ancount,
        # NSCOUNT: Authority Record Count
        nscount: nscount,
        # ARCOUNT: Additional Record Count     
        arcount: arcount
      },
      rest
    }
  end
end
