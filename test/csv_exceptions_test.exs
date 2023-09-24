defmodule CSVExceptionsTest do
  use ExUnit.Case
  import TestSupport.StreamHelpers

  alias CSV.RowLengthError
  alias CSV.StrayEscapeCharacterError

  test "decodes in normal mode emitting errors with row lengths when configured" do
    stream = ~w(a,be a c,d) |> to_line_stream
    result = CSV.decode(stream, validate_row_length: true) |> Enum.to_list()

    assert result == [
             ok: ~w(a be),
             error:
               "Row 2 has length 1 instead of expected length 2\n\n" <>
                 "You are seeing this error because :validate_row_length has been set to true\n",
             ok: ~w(c d)
           ]
  end

  test "decodes in normal mode not overriding errors with a row length error when configured" do
    stream = ~w(a,be a" c,d) |> to_line_stream
    result = CSV.decode(stream, validate_row_length: true) |> Enum.to_list()

    assert result == [
             ok: ~w(a be),
             error:
               "Stray escape character on line 2:\n\na\"\n\n" <>
                 "This error often happens when the wrong separator or escape character has been applied.\n",
             ok: ~w(c d)
           ]
  end

  test "decodes in normal mode redacting error messages when configured" do
    stream = ~w(a,be a" c,d) |> to_line_stream
    result = CSV.decode(stream, redact_errors: true) |> Enum.to_list()

    assert result == [
             ok: ~w(a be),
             error:
               "Stray escape character on line 2:\n\n**redacted**\n\n" <>
                 "This error often happens when the wrong separator or escape character has been applied.\n",
             ok: ~w(c d)
           ]
  end

  test "decodes in strict mode raising errors" do
    stream = ~w(a,be a c,d) |> to_line_stream

    assert_raise RowLengthError, fn ->
      CSV.decode!(stream, validate_row_length: true) |> Stream.run()
    end
  end

  test "decodes in strict mode redacting error messages" do
    stream = ~w(a,be a" c,d) |> to_line_stream

    expected_message =
      "Stray escape character on line 2:\n\n**redacted**\n\n" <>
        "This error often happens when the wrong separator or escape character has been applied.\n"

    assert_raise StrayEscapeCharacterError, expected_message, fn ->
      CSV.decode!(stream) |> Stream.run()
    end
  end

  test "decodes in strict mode allowing error messages to be unredacted" do
    stream = ~w(a,be a" c,d) |> to_line_stream

    expected_message =
      "Stray escape character on line 2:\n\na\"\n\n" <>
        "This error often happens when the wrong separator or escape character has been applied.\n"

    assert_raise StrayEscapeCharacterError, expected_message, fn ->
      CSV.decode!(stream, unredact_exceptions: true) |> Stream.run()
    end
  end

  test "returns encoding errors as is with rows in normal mode" do
    stream = [<<"Diego,Fern", 225, "ndez">>, "John,Smith"] |> to_line_stream
    result = CSV.decode(stream) |> Enum.to_list()

    assert result == [
             ok: ["Diego", <<"Fern", 225, "ndez">>],
             ok: ~w(John Smith)
           ]
  end
end
