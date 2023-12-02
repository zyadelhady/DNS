defmodule Structs.ResourceRecord do
  defstruct [:name, :type, :class, :ttl, :rdlength, :rdata]

  def decode_record({header, question, message}) do
    IO.inspect(message)
    {name, rest} = Decompress.parse_name(message, [])

    {
      header,
      question,
      %__MODULE__{
        name: name
      }
    }
  end
end
