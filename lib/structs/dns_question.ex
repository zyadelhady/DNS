defmodule Structs.DnsQuestion do
  @sizename 16
  @sizetype 16
  @sizeclass 16

  import Bitwise

  defstruct [
    :name,
    :type,
    :class
  ]

  def decode_question({finished, message}) do
    {decoded_name, rest} =
      message
      |> :binary.bin_to_list()
      |> decode_name([])

    {
      finished,
      %__MODULE__{
        # type: type,
        name: decoded_name
        # class: class
      },
      rest
    }
  end

  defp decode_name([], result, rest), do: {List.to_string(result), rest}

  defp decode_name([head | tail], result) do
    case head == 0 do
      true ->
        decode_name([], result, tail)

      false ->
        is_pointer = head >>> 6 == 0b11
        length = head &&& 0x3FFF

        if !is_pointer do
          {domain, next} = tail |> Enum.split(length)
          domain_with_dot = domain ++ [46]
          result = result ++ domain_with_dot
          decode_name(next, result)
        end
    end
  end
end
