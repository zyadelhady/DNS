defmodule Structs.DnsHeader do
  @moduledoc """
  DNS Header Structure.

  This module defines a struct representing the header of a DNS message.
  """


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
end
