defmodule Inputs do
  def instructions do
    get_strings()
    |> get_lines()
    |> Enum.map(&parse_instructions/1)
  end

  defp parse_instructions(inst) do
    inst
    |> Enum.map(fn coord ->
      [direction] = coord |> String.split(~r/\d/, trim: true)
      direction = String.to_atom(direction)
      [steps] = coord |> String.split(~r/[A-Z]/, trim: true)
      {steps, _} = steps |> Integer.parse()
      {direction, steps}
    end)
  end

  defp get_lines(strings) do
    strings |> Enum.map(fn str -> str |> String.split(~r/,/) end)
  end

  defp get_strings do
    read_inputs() |> String.split(~r/\n/)
  end

  defp read_inputs do
    get_path() |> File.read!()
  end

  defp get_path do
    "../lib/puuzle_inputs.txt" |> Path.expand(__DIR__)
  end
end
