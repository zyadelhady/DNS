defmodule Decompress do
  import Bitwise

  def parse_name(result, stopped_at), do: {List.to_string(result), stopped_at}

  def parse_name(message, start, result) do
    {_, [head | tail]} = Enum.split(message, start)

    # IO.inspect(head)

    case head == 0 do
      true ->
        parse_name(result, start)

      false ->
        is_pointer = head >>> 6 == 0b11
        length = head &&& 0x3FFF

        if !is_pointer do
          {domain, next} = tail |> Enum.split(length)
          domain_with_dot = domain ++ [46]
          result = result ++ domain_with_dot
          parse_name(message, start + length + 1, result)
        end
    end
  end
end
