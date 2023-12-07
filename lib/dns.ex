defmodule Dns do
  @moduledoc """
  Documentation for `Dns`.
  """

  import Bitwise
  alias Credo.Check.Refactor.IoPuts
  alias Structs.DnsMessage
  alias Structs.ResourceRecord
  alias Structs.DnsQuestion
  alias Structs.DnsHeader
  require Logger

  @size_id 16
  @size_flags 16
  @size_qdcount 16
  @size_ancount 16
  @size_nscount 16
  @size_arcount 16

  def handle() do
    {:ok, message_read} = File.read("message")

    message = :binary.bin_to_list(message_read)

    {message, 0, %DnsMessage{}}
    |> decode_header()
    |> decode_question()
    |> decode_authortives_section()
    |> IO.inspect()
  end

  @doc """
  Decodes a binary message into a DNS header struct.

  ## Parameters

  - `message`: Binary representation of a DNS message.

  ## Returns

  A tuple with the decoded DNS header struct and the remaining message.
  """
  def decode_header({message, start, parsed_message}) do
    flags = decode_header_value(message, 2, 2)

    {
      message,
      12,
      %Structs.DnsMessage{
        parsed_message
        | header: %Structs.DnsHeader{
            id: decode_header_value(message, 0, 2),
            # QR: Query/Response flag
            qr: flags >>> 15 == 1,
            # # OPCODE: Operation Code
            opcode: flags >>> 11 &&& 0b1111,
            # # AA: Authoritative Answer flag
            aa: (flags >>> 10 &&& 0b1) == 1,
            # # TC: TrunCation flag
            tc: (flags >>> 9 &&& 0b1) == 1,
            # # RD: Recursion Desired flag
            rd: (flags >>> 8 &&& 0b1) == 1,
            # # RA: Recursion Available flag
            ra: (flags >>> 7 &&& 0b1) == 1,
            # # Z: Reserved field
            z: flags >>> 4 &&& 0b111,
            # # RCODE: Response Code
            rcode: flags &&& 0b1111,
            # QDCOUNT: Question Count
            qdcount: decode_header_value(message, 4, 2),
            # ANCOUNT: Answer Record Count
            ancount: decode_header_value(message, 6, 2),
            # NSCOUNT: Authority Record Count
            nscount: decode_header_value(message, 8, 2),
            # ARCOUNT: Additional Record Count     
            arcount: decode_header_value(message, 10, 2)
          }
      }
    }
  end

  def decode_header_value(message, start, finish) do
    message
    |> Enum.slice(start, finish)
    |> :binary.list_to_bin()
    |> :binary.decode_unsigned(:big)
  end

  def decode_question({message, start, parsed_message}) do
    {decoded_name, stopped_at} =
      message
      |> parse_name(start, [])

    type_class = Enum.slice(message, stopped_at..(stopped_at + 3))
    {type, class} = extract_type_and_class(type_class)

    {
      message,
      stopped_at + 4,
      %Structs.DnsMessage{
        parsed_message
        | question: %Structs.DnsQuestion{
            type: type,
            name: decoded_name,
            class: class
          }
      }
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

  def decode_authortives_section({message, start, parsed_message}) do
    header = parsed_message.header
    datal = header.nscount

    {rrs, last} = parse_rr(message, start, [], datal)

    {
      message,
      last,
      %DnsMessage{
        parsed_message
        | resource_records: rrs
      }
    }
  end

  def parse_rr(message, start, rrs, index) do
    case index == 0 do
      true ->
        {rrs, start}

      false ->
        {decoded_name, stopped_at} =
          message
          |> parse_name(start, [])

        type_class = Enum.slice(message, stopped_at..(stopped_at + 3))
        {type, class} = extract_type_and_class(type_class)

        stopped_at = stopped_at + 4

        ttl =
          Enum.slice(message, stopped_at..(stopped_at + 3))
          |> :binary.list_to_bin()
          |> :binary.decode_unsigned(:big)

        stopped_at = stopped_at + 4

        rdl =
          Enum.slice(message, stopped_at..(stopped_at + 1))
          |> :binary.list_to_bin()
          |> :binary.decode_unsigned(:big)

        stopped_at = stopped_at + 2

        {decoded_server_name, last} = parse_name(message, stopped_at, [])

        rrs = [
          %ResourceRecord{
            rdata: decoded_server_name,
            name: decoded_name,
            type: type,
            class: class,
            ttl: ttl,
            rdlength: rdl
          }
          | rrs
        ]

        parse_rr(message, last, rrs, index - 1)
    end
  end

  def is_pointer(octet) do
    octet >>> 6 == 0b11
  end

  def parse_name(message, start, result) do
    case Enum.at(message, start) == 0 do
      true ->
        {List.to_string(result), start + 1}

      false ->
        {label, last, continue} =
          is_pointer(Enum.at(message, start))
          |> Decompress.parse_label(message, start)

        if continue do
          parse_name(message, last, result ++ label)
        else
          {List.to_string(result ++ label), last}
        end
    end
  end

  def decode_server_name(message, start, length) do
    list = Enum.slice(message, start, length)
    result = []

    for octet <- list do
      ispointer = is_pointer(hd(list))
    end
  end
end
