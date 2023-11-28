defmodule RRRecord do
  @type t :: %__MODULE__{
          name: String.t(),
          ttl: non_neg_integer(),
          class: String.t(),
          type: non_neg_integer(),
          address: String.t()
        }
  defstruct [:name, :ttl, :class, :type, :address]

  def construct([name, ttl, class, type, address]) do
    %RRRecord{name: name, ttl: String.to_integer(ttl), class: class, type: type, address: address}
  end

  @spec get(String.t()) :: t()
  def get(key) do
    RRRecord[String.to_atom(key)]
  end
end
