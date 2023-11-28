defmodule ZoneRecord do
  @type t :: %__MODULE__{
          domain: String.t(),
          RRs: list(RRRecord.t())
        }
  defstruct [:domain, :RRs]
end
