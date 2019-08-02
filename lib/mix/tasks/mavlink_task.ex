defmodule Mix.Tasks.Mavlink do
  use Mix.Task

  
  import Mavlink.Parser
  import DateTime
  import Enum, only: [count: 1, join: 2, map: 2, filter: 2, reduce: 3, reverse: 1, sort: 1, into: 3]
  import String, only: [trim: 1, replace: 3, split: 2, capitalize: 1, downcase: 1]
  import Mavlink.Utils
  
  use Bitwise, only_operators: true
  
  
  @shortdoc "Generate Mavlink Module from XML"
  @spec run([String.t]) :: :ok
  def run([input, output]) do
    case parse_mavlink_xml(input) do
      {:error, message} ->
        IO.puts message
        
      %{version: version, dialect: dialect, enums: enums, messages: messages} ->
     
        enum_code_fragments = get_enum_code_fragments(enums)
        message_code_fragments = get_message_code_fragments(messages, enums)
        unit_code_fragments = get_unit_code_fragments(messages)
        
        :ok = File.write(output,
        """
        defmodule Mavlink.Types do
        
          @typedoc "A parameter description"
          @type param_description :: {pos_integer, String.t}
          
          
          @typedoc "A list of parameter descriptions"
          @type param_description_list :: [ param_description ]
          
          
          @typedoc "Type used for field in encoded message"
          @type field_type :: int8_t | int16_t | int32_t | int64_t | uint8_t | uint16_t | uint32_t | uint64_t | char | float | double
          
          
          @typedoc "8-bit signed integer"
          @type int8_t :: -128..127
          
          
          @typedoc "16-bit signed integer"
          @type int16_t :: -32_768..32_767
          
          
          @typedoc "32-bit signed integer"
          @type int32_t :: -2_147_483_647..2_147_483_647
          
          
          @typedoc "64-bit signed integer"
          @type int64_t :: integer
          
          
          @typedoc "8-bit unsigned integer"
          @type uint8_t :: 0..255
          
          
          @typedoc "16-bit unsigned integer"
          @type uint16_t :: 0..65_535
          
          
          @typedoc "32-bit unsigned integer"
          @type uint32_t :: 0..4_294_967_295
          
          
          @typedoc "64-bit unsigned integer"
          @type uint64_t :: pos_integer
          
          
          @typedoc "64-bit signed float"
          @type double :: Float64
          
          
          @typedoc "1 -> not an array 2..255 -> an array"
          @type field_ordinality :: 1..255
          
          
          @typedoc "A Mavlink message id"
          @type message_id :: non_neg_integer
          
          
          @typedoc "A CRC_EXTRA checksum"
          @type crc_extra :: 0..255
          
          
          @typedoc "A Mavlink message"
          @type message :: #{map(messages, & "Mavlink.Message.#{&1[:name] |> module_case}") |> join(" | ")}
          
          
          @typedoc "An atom representing a Mavlink enumeration type"
          @type enum_type :: #{map(enums, & ":#{&1[:name]}") |> join(" | ")}
          
          
          @typedoc "An atom representing a Mavlink enumeration type value"
          @type enum_value :: #{map(enums, & "#{&1[:name]}") |> join(" | ")}
          
          
          @typedoc "Measurement unit of field value"
          @type field_unit :: #{unit_code_fragments |> join(~s( | )) |> trim}
          
          
          #{enum_code_fragments |> map(& &1[:type]) |> join("\n\n  ")}
        
        end
        
        
        defprotocol Mavlink.Pack do
          @spec pack(Mavlink.Types.message) :: {:ok, Mavlink.Types.message_id, binary()} | {:error, String.t}
          def pack(message)
        end
        
        
        defimpl Mavlink.Pack, for: [Atom, BitString, Float, Function, Integer, List, Map, PID, Port, Reference, Tuple] do
          def pack(not_a_message), do: {:error, "pack(): \#{inspect(not_a_message)} is not a Mavlink message"}
        end
        
        
        #{message_code_fragments |> map(& &1.module) |> join("\n\n") |> trim}
        
        
        defmodule Mavlink do
        
          import String, only: [replace_trailing: 3]
          import Mavlink.Utils, only: [unpack_array: 2, unpack_bitmask: 3]
          
          use Bitwise, only_operators: true
        
          @moduledoc ~s(Mavlink #{version}.#{dialect} generated by Mavlink mix task from #{input} on #{utc_now()})
        
          
          @doc "Mavlink version"
          @spec mavlink_version() :: #{version}
          def mavlink_version(), do: #{version}
          
          
          @doc "Mavlink dialect"
          @spec mavlink_dialect() :: #{dialect}
          def mavlink_dialect(), do: #{dialect}
          
          
          @doc "Return a String description of a Mavlink enumeration"
          @spec describe(Mavlink.Types.enum_type | Mavlink.Types.enum_value) :: String.t
          #{enum_code_fragments |> map(& &1[:describe]) |> join("\n  ") |> trim}
          
          
          @doc "Return keyword list of mav_cmd parameters"
          @spec describe_params(Mavlink.Types.mav_cmd) :: Mavlink.Types.param_description_list
          #{enum_code_fragments |> map(& &1[:describe_params]) |> join("\n  ") |> trim}
          
          
          @doc "Return encoded integer value used in a Mavlink message for an enumeration value"
          #{enum_code_fragments |> map(& &1[:encode_spec]) |> join("\n  ") |> trim}
          #{enum_code_fragments |> map(& &1[:encode]) |> join("\n  ") |> trim}
          
          
          @doc "Return the atom representation of a Mavlink enumeration value from the enumeration type and encoded integer"
          #{enum_code_fragments |> map(& &1[:decode_spec]) |> join("\n  ") |> trim}
          #{enum_code_fragments |> map(& &1[:decode]) |> join("\n  ") |> trim}
          def decode(_enum, _value), do: {:error, :no_such_enum}
          
          
          @doc "Return the message checksum and size in bytes for a message with a specified id"
          @spec msg_crc_size(Mavlink.Types.message_id) :: {Mavlink.Types.crc_extra, pos_integer} | {:error, :unknown_message_id}
          #{message_code_fragments |> map(& &1.msg_crc_size) |> join("") |> trim}
          def msg_crc_size(_), do: {:error, :unknown_message_id}
        
        
          @doc "Unpack a Mavlink message given a Mavlink frame's message id and payload"
          @spec unpack(Mavlink.Types.message_id, binary) :: Mavlink.Types.message | {:error, :unknown_message}
          #{message_code_fragments |> map(& &1.unpack) |> join("") |> trim}
          def unpack(_, _), do: {:error, :unknown_message}
          
        end
        """
        )
      
        IO.puts("Generated output file '#{output}'.")
        :ok
    
    end
    
  end
  
  
  @type enum_detail :: %{type: String.t, describe: String.t, describe_params: String.t, encode: String.t, decode: String.t}
  @spec get_enum_code_fragments([Mavlink.Parser.enum_description]) :: [ enum_detail ]
  defp get_enum_code_fragments(enums) do
    for enum <- enums do
      %{
        name: name,
        description: description,
        entries: entries
      } = enum
      
      entry_code_fragments = get_entry_code_fragments(name, entries)
      
      %{
        type: ~s/@typedoc "#{description}"\n  / <>
          ~s/@type #{name} :: / <>
          (map(entry_code_fragments, & ":#{&1[:name]}") |> join(" | ")),
          
        describe: ~s/def describe(:#{name}), do: "#{escape(description)}"\n  / <>
          (map(entry_code_fragments, & &1[:describe])
          |> join("\n  ")),
          
        describe_params: filter(entry_code_fragments, & &1 != nil)
          |> map(& &1[:describe_params])
          |> join("\n  "),
      
        encode_spec: "@spec encode(Mavlink.Types.#{name}, :#{name}) :: " <>
          (map(entry_code_fragments, & &1[:value])
          |> join(" | ")),
          
        encode: map(entry_code_fragments, & &1[:encode])
          |> join("\n  "),
      
        decode_spec: "@spec decode(integer, :#{name}) :: Mavlink.Types.#{name}",
        
        decode: map(entry_code_fragments, & &1[:decode])
          |> join("\n  ")
      }
    end
  end
  
  
  @type entry_detail :: %{name: String.t, describe: String.t, describe_params: String.t, encode: String.t, decode: String.t}
  @spec get_entry_code_fragments(String.t, [Mavlink.Parser.entry_description]) :: [ entry_detail ]
  defp get_entry_code_fragments(enum_name, entries) do
    {details, _} = reduce(
      entries,
      {[], 0},
      fn entry, {details, next_value} ->
        %{
          name: entry_name,
          description: entry_description,
          value: entry_value,
          params: entry_params
        } = entry
        
        # Use provided value or continue monotonically from last value: in common.xml MAV_STATE uses this
        {entry_value_string, next_value} = case entry_value do
          nil ->
            {Integer.to_string(next_value), next_value + 1}
          _ ->
            {Integer.to_string(entry_value), entry_value + 1}
        end
        
        {
          [
            %{
              name: entry_name,
              describe: ~s/def describe(:#{entry_name}), do: "#{escape(entry_description)}"/,
              describe_params: get_param_code_fragments(entry_name, entry_params),
              encode: ~s/def encode(:#{entry_name}, :#{enum_name}), do: #{entry_value_string}/,
              decode: ~s/def decode(#{entry_value_string}, :#{enum_name}), do: :#{entry_name}/,
              value: entry_value_string
            }
            | details
          ],
          next_value
        }

      end
    )
    reverse(details)
  end
  
  
  @spec get_param_code_fragments(String.t, [Mavlink.Parser.param_description]) :: String.t
  defp get_param_code_fragments(entry_name, entry_params) do
    cond do
      count(entry_params) == 0 ->
        nil
      true ->
        ~s/def describe_params(:#{entry_name}), do: [/ <>
        (map(entry_params, & ~s/{#{&1[:index]}, "#{&1[:description]}"}/) |> join(", ")) <>
        ~s/]/
    end
  end
  
  
  @spec get_message_code_fragments([Mavlink.Parser.message_description], [enum_detail]) :: [ String.t ]
  defp get_message_code_fragments(messages, enums) do
    # Lookup used by looks_like_a_bitmask?()
    enums_by_name = into(enums, %{}, fn (enum) -> {Atom.to_string(enum.name), enum} end)

    for message <- messages do
      module_name = message.name |> module_case
      field_names = message.fields |> map(& ":" <> downcase(&1.name)) |> join(", ")
      field_types = message.fields |> map(& downcase(&1.name) <> ": " <> field_type(&1)) |> join(", ")
      wire_order = message.fields |> wire_order
      
      # Have to append "_f" to stop clash with reserved elixir words like "end"
      unpack_binary_pattern = wire_order |> map(& downcase(&1.name) <> "_f::" <> type_to_binary(&1).pattern) |> join(",")
      unpack_struct_fields = message.fields |> map(& downcase(&1.name) <> ": " <> unpack_field_code_fragment(&1, enums_by_name)) |> join(", ")
      pack_binary_pattern = wire_order |> map(& pack_field_code_fragment(&1, enums_by_name)) |> join(",")
      crc_extra = message |> calculate_message_crc_extra
      expected_payload_size = reduce(message.fields, 0, fn(field, sum) -> sum + type_to_binary(field).size end) # Without Mavlink 2 trailing 0 truncation
      %{
        msg_crc_size:
          """
            def msg_crc_size(#{message.id}), do: {:ok, #{crc_extra}, #{expected_payload_size}}
          """,
        unpack:
          """
            def unpack(#{message.id}, <<#{unpack_binary_pattern}>>), do: {:ok, %Mavlink.Message.#{module_name}{#{unpack_struct_fields}}}
          """,
        module:
          """
          defmodule Mavlink.Message.#{module_name} do
            @enforce_keys [#{field_names}]
            defstruct [#{field_names}]
            @typedoc "#{escape(message.description)}"
            @type t :: %Mavlink.Message.#{module_name}{#{field_types}}
            defimpl Mavlink.Pack do
              def pack(msg), do: {:ok, #{message.id}, <<#{pack_binary_pattern}>>}
            end
          end
          """
      }
    end
  end
  
  @spec calculate_message_crc_extra(Mavlink.Parser.message_description) :: Mavlink.Types.crc_extra
  defp calculate_message_crc_extra(message) do
    reduce(
      message.fields |> wire_order |> filter(& !&1.is_extension),
      x25_crc(message.name <> " "),
      fn(field, crc) ->
        case field.ordinality do
          1 ->
            crc |> x25_crc(field.type <> " ") |> x25_crc(field.name <> " ")
          _ ->
            crc |> x25_crc(field.type <> " ") |> x25_crc(field.name <> " ") |> x25_crc([field.ordinality])
        end
      end
    ) |> eight_bit_checksum
  end
  
  
  # Unpack Message Fields
  
  defp unpack_field_code_fragment(%{name: name, ordinality: 1, enum: ""}, _) do
    downcase(name) <> "_f"
  end
  
  defp unpack_field_code_fragment(%{name: name, ordinality: 1, enum: enum, display: :bitmask}, _) when enum != "" do
    "unpack_bitmask(#{downcase(name)}_f, :#{enum}, &decode/2)"
  end
  
  defp unpack_field_code_fragment(%{name: name, ordinality: 1, enum: enum}, enums_by_name) do
    case looks_like_a_bitmask?(enums_by_name[enum]) do
      true ->
        IO.puts(~s[Warning: assuming #{enum} is a bitmask although display="bitmask" not set])
        "unpack_bitmask(#{downcase(name)}_f, :#{enum}, &decode/2)"
      false ->
        "decode(#{downcase(name)}_f, :#{enum})"
    end
  end
  
  defp unpack_field_code_fragment(%{name: name, type: "char"}, _) do
    ~s[replace_trailing(#{downcase(name)}_f, <<0>>, "")]
  end
  
  defp unpack_field_code_fragment(field, _) do
    "unpack_array(#{downcase(field.name)}_f, fn(<<elem::#{type_to_binary(field).pattern},rest::binary>>) ->  {elem, rest} end)"
  end
  
  
  # Pack Message Fields
  
  defp pack_field_code_fragment(field=%{name: name, ordinality: 1, enum: ""}, _) do
    "msg.#{downcase(name)}::#{type_to_binary(field).pattern}"
  end
  
  defp pack_field_code_fragment(field=%{name: name, ordinality: 1, enum: enum, display: :bitmask}, _) when enum != "" do
    "Mavlink.Utils.pack_bitmask(msg.#{downcase(name)}, :#{enum}, &Mavlink.encode/2)::#{type_to_binary(field).pattern}"
  end
  
  defp pack_field_code_fragment(field=%{name: name, ordinality: 1, enum: enum}, enums_by_name) do
    case looks_like_a_bitmask?(enums_by_name[enum]) do
      true ->
        "Mavlink.Utils.pack_bitmask(msg.#{downcase(name)}, :#{enum}, &Mavlink.encode/2)::#{type_to_binary(field).pattern}"
      false ->
        "Mavlink.encode(msg.#{downcase(name)}, :#{enum})::#{type_to_binary(field).pattern}"
    end
  end
  
  defp pack_field_code_fragment(%{name: name, ordinality: ordinality, type: "char"}, _) do
    "Mavlink.Utils.pack_string(msg.#{downcase(name)}, #{ordinality})::binary-size(#{ordinality})"
  end
  
  defp pack_field_code_fragment(field, _) do
    "Mavlink.Utils.pack_array(msg.#{downcase(field.name)}, #{field.ordinality}, fn(elem) -> <<elem::#{type_to_binary(field).pattern}>> end)::binary-size(#{type_to_binary(field).size})"
  end
  
  
  @spec get_unit_code_fragments([Mavlink.Parser.message_description]) :: [ String.t ]
  defp get_unit_code_fragments(messages) do
    reduce(
      messages,
      MapSet.new(),
      fn message, units ->
        reduce(
          message.fields,
          units,
          fn %{units: next_unit}, units ->
            cond do
              next_unit == nil ->
                units
              Regex.match?(~r/^[a-zA-Z0-9@_]+$/, Atom.to_string(next_unit)) ->
                MapSet.put(units, ~s(:#{next_unit}))
              true ->
                MapSet.put(units, ~s(:"#{next_unit}"))
            end
            
          end
        )
      end
    ) |> MapSet.to_list |> Enum.sort
  end
  
  
  @spec module_case(String.t) :: String.t
  defp module_case(name) do
    name
    |> split("_")
    |> map(&capitalize/1)
    |> join("")
  end
  
  
  # Some bitmask fields e.g. Mavlink.EkfStatusReport.flags are not marked with display="bitmask". This function
  # returns true if the enum entry values start with 1, 2, 4 and then continue increasing through powers of 2.
  defp looks_like_a_bitmask?(%{entries: entries}), do: looks_like_a_bitmask?(entries |> map(& &1.value) |> sort)
  defp looks_like_a_bitmask?([1, 2, 4 | rest]), do: looks_like_a_bitmask?(rest)
  defp looks_like_a_bitmask?([8 | rest]), do: looks_like_a_bitmask?(rest |> map(& &1 >>> 1))
  defp looks_like_a_bitmask?([]), do: true
  defp looks_like_a_bitmask?(_), do: false
  
  
  # Have to deal with some overlap between MAVLink and Elixir types
  defp field_type(%{type: type, ordinality: ordinality, enum: enum}) when ordinality > 1, do: "[ #{field_type(%{type: type, ordinality: 1, enum: enum})} ]"
  defp field_type(%{enum: enum, display: :bitmask}) when enum != "", do: "MapSet.t(Mavlink.Types.#{enum})"
  defp field_type(%{enum: enum}) when enum != "", do: "Mavlink.Types.#{enum}"
  defp field_type(%{type: "char"}), do: "char"
  defp field_type(%{type: "float"}), do: "Float32"
  defp field_type(%{type: "double"}), do: "Float64"
  defp field_type(%{type: type}), do: "Mavlink.Types.#{type}"
  
  
  # Map field types to a binary pattern code fragment and a size
  defp type_to_binary(%{type: type, ordinality: 1}), do: type_to_binary(type)
  defp type_to_binary(%{type: "char", ordinality: n}), do: %{pattern: "binary-size(#{n})", size: n}
  defp type_to_binary(%{type: "uint8_t", ordinality: n}), do: %{pattern: "binary-size(#{n})", size: n}
  defp type_to_binary(%{type: "int8_t", ordinality: n}), do: %{pattern: "binary-size(#{n})", size: n}
  defp type_to_binary(%{type: "uint16_t", ordinality: n}), do: %{pattern: "binary-size(#{n * 2})", size: n * 2}
  defp type_to_binary(%{type: "int16_t", ordinality: n}), do: %{pattern: "binary-size(#{n * 2})", size: n * 2}
  defp type_to_binary(%{type: "uint32_t", ordinality: n}), do: %{pattern: "binary-size(#{n * 4})", size: n * 2}
  defp type_to_binary(%{type: "int32_t", ordinality: n}), do: %{pattern: "binary-size(#{n * 4})", size: n * 4}
  defp type_to_binary(%{type: "uint64_t", ordinality: n}), do: %{pattern: "binary-size(#{n * 8})", size: n * 8}
  defp type_to_binary(%{type: "int64_t", ordinality: n}), do: %{pattern: "binary-size(#{n * 8})", size: n * 8}
  defp type_to_binary(%{type: "float", ordinality: n}), do: %{pattern: "binary-size(#{n * 4})", size: n * 4}
  defp type_to_binary(%{type: "double", ordinality: n}), do: %{pattern: "binary-size(#{n * 8})", size: n * 8}
  defp type_to_binary("char"), do: %{pattern: "integer-size(8)", size: 1}
  defp type_to_binary("uint8_t"), do: %{pattern: "integer-size(8)", size: 1}
  defp type_to_binary("int8_t"), do: %{pattern: "signed-integer-size(8)", size: 1}
  defp type_to_binary("uint16_t"), do: %{pattern: "little-integer-size(16)", size: 2}
  defp type_to_binary("int16_t"), do: %{pattern: "little-signed-integer-size(16)", size: 2}
  defp type_to_binary("uint32_t"), do: %{pattern: "little-integer-size(32)", size: 4}
  defp type_to_binary("int32_t"), do: %{pattern: "little-signed-integer-size(32)", size: 4}
  defp type_to_binary("uint64_t"), do: %{pattern: "little-integer-size(64)", size: 8}
  defp type_to_binary("int64_t"), do: %{pattern: "little-signed-integer-size(64)", size: 8}
  defp type_to_binary("float"), do: %{pattern: "little-signed-float-size(32)", size: 4}
  defp type_to_binary("double"), do: %{pattern: "little-signed-float-size(64)", size: 8}
  
  
  @spec escape(String.t) :: String.t
  defp escape(s) do
    replace(s, ~s("), ~s(\\"))
  end
  
  
end
