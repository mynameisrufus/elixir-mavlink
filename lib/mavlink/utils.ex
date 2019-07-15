defmodule Mavlink.Utils do
  @moduledoc ~s"""
  Mavlink support functions used during code generation and runtime
  Parts of this module are ported from corresponding implementations
  in mavutils.py
  """
  
  
  use Bitwise, only_operators: true
  
  
  import List, only: [flatten: 1]
  import Enum, only: [sort_by: 2]
  
  
  @doc """
  Sort parsed message fields into wire order according
  to https://mavlink.io/en/guide/serialization.html
  """
  @spec wire_order([ ]) :: [ ]
  def wire_order(fields) do
    type_order_map = %{
      uint64_t:                 1,
      int64_t:                  1,
      double:                   1,
      uint32_t:                 2,
      int32_t:                  2,
      float:                    2,
      uint16_t:                 3,
      int16_t:                  3,
      uint8_t:                  4,
      uint8_t_mavlink_version:  4,
      int8_t:                   4,
      char:                     4
    }
    
    sort_by(fields, &Map.fetch(type_order_map, String.to_atom(&1.type)))
    
  end
  
  
  @doc """
  Calculate an x25 checksum of a list or binary based on
  pymavlink mavcrc.x25crc
  """
  
  
  def eight_bit_checksum(value) do
    (value &&& 0xFF) ^^^ (value >>> 8)
  end
  
  
  @spec x25_crc([ ] | binary()) :: pos_integer
  def x25_crc(list) when is_list(list) do
    x25_crc(0xffff, flatten(list))
  end
  
  def x25_crc(bin) when is_binary(bin) do
    x25_crc(0xffff, bin)
  end
  
  def x25_crc(crc, []), do: crc
  
  def x25_crc(crc, <<>>), do: crc
  
  def x25_crc(crc, [head | tail]) do
    crc |> x25_accumulate(head) |> x25_crc(tail)
  end
  
  def x25_crc(crc, << head :: size(8), tail :: binary>>) do
    crc |> x25_accumulate(head) |> x25_crc(tail)
  end
  
  
  defp x25_accumulate(crc, value) do
    tmp = value ^^^ (crc &&& 0xff)
    tmp = (tmp ^^^ (tmp <<< 4)) &&& 0xff
    crc = (crc >>> 8) ^^^ (tmp <<< 8) ^^^ (tmp <<< 3) ^^^ (tmp >>> 4)
    crc &&& 0xffff
  end
  
end
