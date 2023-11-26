defmodule DecodeTypespectest do
  @moduledoc "Test decoding typespecs"

  def test_decode_no_options do
    ["dummy,input"] |> CSV.decode() |> Enum.to_list()
  end

  def test_decode_option_escape_character do
    ["dummy,input"] |> CSV.decode(escape_character: ?.) |> Enum.to_list()
  end

  def test_decode_option_separator do
    ["dummy,input"] |> CSV.decode(separator: ?.) |> Enum.to_list()
  end

  def test_decode_option_unescape_formulas do
    ["dummy,input"] |> CSV.decode(unescape_formulas: true) |> Enum.to_list()
  end

  def test_decode_option_escape_max_lines do
    ["dummy,input"] |> CSV.decode(escape_max_lines: 10) |> Enum.to_list()
  end

  def test_decode_option_validate_row_length do
    ["dummy,input"] |> CSV.decode(validate_row_length: true) |> Enum.to_list()
  end

  def test_decode_option_field_transform do
    ["dummy,input"] |> CSV.decode(field_transform: fn s -> s end) |> Enum.to_list()
  end

  def test_decode_option_headers_list do
    ["dummy,input"] |> CSV.decode(headers: ["a", "b"]) |> Enum.to_list()
  end

  def test_decode_option_headers_atom_list do
    ["dummy,input"] |> CSV.decode(headers: [:a, :b]) |> Enum.to_list()
  end

  def test_decode_combined do
    ["dummy,input"] |> CSV.decode(headers: [:a, :b], separator: ?,, validate_row_length: true) |> Enum.to_list()
  end

  def test_decode_option_combine_with_redact_errors do
    ["dummy,input"] |> CSV.decode(headers: [:a, :b], redact_errors: false) |> Enum.to_list()
  end

  def test_decode_strict_no_options do
    ["dummy,input"] |> CSV.decode!() |> Enum.to_list()
  end

  def test_decode_strict_headers do
    ["dummy,input"] |> CSV.decode!(headers: [:a, :b]) |> Enum.to_list()
  end

  def test_decode_strict_combined do
    ["dummy,input"] |> CSV.decode!(headers: [:a, :b], separator: ?,, validate_row_length: true) |> Enum.to_list()
  end

  def test_decode_strict_option_combine_with_unredact_exceptions do
    ["dummy,input"] |> CSV.decode!(headers: [:a, :b], unredact_exceptions: true) |> Enum.to_list()
  end
end
