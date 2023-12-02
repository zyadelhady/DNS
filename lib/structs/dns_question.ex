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

  def decode_question({header, rest_message}) do
    {decoded_name, rest} =
      rest_message
      |> :binary.bin_to_list()
      |> decode_name([])

    {type_class, return_rest} = Enum.split(rest, 4)

    {type, class} = extract_type_and_class(type_class)

    {
      header,
      %__MODULE__{
        type: type,
        name: decoded_name,
        class: class
      },
      return_rest
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

  defp extract_type_and_class(list) do
    {type, class} = Enum.split(list, 2)
    decimal_type = type |> get_decimal
    decimal_class = class |> get_decimal
    {decimal_type, decimal_class}

  end

  defp get_decimal(list) do
    Enum.reduce(list, 0, fn bit, acc ->
      acc * 2 + bit
    end)
  end
end



