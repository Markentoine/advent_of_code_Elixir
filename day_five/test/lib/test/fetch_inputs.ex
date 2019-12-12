defmodule Test.FetchInputs do
  def array_inputs, do: :array.from_list(list_inputs())

  # PRIVATE
  defp list_inputs, do: parse_inputs() |> Enum.map(&String.to_integer/1)

  defp parse_inputs, do: read_inputs() |> String.split(~r/,/)

  defp read_inputs, do: get_path() |> File.read!()

  defp get_path, do: "../test/inputs.text" |> Path.expand(__DIR__)
end
