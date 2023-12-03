defmodule Decompress do
  import Bitwise

  def parse_name([], result, rest, l), do: {List.to_string(result), rest, l}

  def parse_name([head | tail], result, l) do
    # IO.inspect(head)

    case head == 0 do
      true ->
        parse_name([], result, tail, l)

      false ->
        is_pointer = head >>> 6 == 0b11
        length = head &&& 0x3FFF

        if !is_pointer do
          {domain, next} = tail |> Enum.split(length)
          domain_with_dot = domain ++ [46]
          result = result ++ domain_with_dot
          parse_name(next, result, length + l)
        end
    end
  end
end
