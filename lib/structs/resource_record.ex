defmodule Structs.ResourceRecord do
  defstruct [:name, :type, :class, :ttl, :rdlength, :rdata]

  def decode_record({header, question, message}) do
    IO.inspect(message)
    [head | tail] = message
    {name, rest} = Decompress.parse_name(head, [])

    {
      header,
      question,
      %__MODULE__{
        name: name
      }
    }
  end
end
