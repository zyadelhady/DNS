defmodule Decompress do
  import Bitwise

  def parse_label(false, message, start) do
    l = Enum.at(message, start) &&& 0x3FFF
    {Enum.slice(message, (start + 1)..(start + l)) ++ [46], start + l + 1, true}
  end

  def parse_label(true, message, start) do
    pointer =
      message
      |> Enum.slice(start..(start + 1))
      |> :binary.list_to_bin()
      |> :binary.decode_unsigned(:big)

    pointer = pointer &&& 0x3FFF

    {decoded_name, _, _} = parse_label(false, message, pointer)

    {decoded_name, start + 2, false}
  end
end
