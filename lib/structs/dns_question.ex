defmodule Structs.DnsQuestion do
  import Bitwise

  defstruct [
    :name,
    :type,
    :class
  ]
end
