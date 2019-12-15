defmodule FetchInputs do
  def parse_inputs do
    read_inputs() |> String.split("\n")
  end

  defp read_inputs do
    get_path() |> File.read!()
  end

  defp get_path do
    "./inputs.txt" |> Path.expand(__DIR__)
  end
end
