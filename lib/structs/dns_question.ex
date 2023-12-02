defmodule Structs.DnsQuestion do
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
      |> Decompress.parse_name([])

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
