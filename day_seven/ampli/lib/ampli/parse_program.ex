defmodule Ampli.ParseProgram do
  def parse(inst) do
    strInst = stringifyInst(inst)
    [modes, opcode] = String.split(strInst, ~r/\d\d$/, include_captures: true, trim: true)

    [first, second, third] =
      String.split(modes, "", trim: true) |> Enum.reverse() |> Enum.map(&String.to_integer/1)

    parsedOpCode = opcode |> String.to_integer()
    [opCode: parsedOpCode, modes: [{1, first, :read}, {2, second, :read}, {3, third, :write}]]
  end

  # PRIVATE

  defp stringifyInst(inst) when inst < 10 do
    "0000" <> Integer.to_string(inst)
  end

  defp stringifyInst(inst) when inst < 100 do
    "000" <> Integer.to_string(inst)
  end

  defp stringifyInst(inst) when inst < 1000 do
    "00" <> Integer.to_string(inst)
  end

  defp stringifyInst(inst) when inst < 10000 do
    "0" <> Integer.to_string(inst)
  end

  defp stringifyInst(inst), do: Integer.to_string(inst)
end
