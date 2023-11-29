defmodule Structs.RRRecord do
  @type t :: %__MODULE__{
          name: String.t(),
          ttl: non_neg_integer(),
          class: String.t(),
          type: non_neg_integer(),
          address: String.t()
        }
  defstruct [:name, :ttl, :class, :type, :address]
end
