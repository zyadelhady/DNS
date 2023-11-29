defmodule Structs.ZoneRecord do
  @type t :: %__MODULE__{
          domain: String.t(),
          RRs: list(Structs.RRRecord.t())
        }
  defstruct [:domain, :RRs]
end
