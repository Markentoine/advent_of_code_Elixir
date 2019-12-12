defmodule Test.Process do
  def runTest do
    id = IO.gets("Enter ID:") |> String.split("\n") |> List.first() |> String.to_integer()
    state = Test.FetchInputs.array_inputs()
    instructions = :array.get(0, state) |> Test.ParseInstruction.parse()
    process(instructions, 0, state, id)
  end

  # PRIVATE

  defp process([opCode: 99, modes: _], _headpos, _state, _input) do
    :stop
  end

  defp process([opCode: 1, modes: modes], headpos, state, _input) do
    {v1, v2, mem_store} = get_params(headpos, modes, state)
    new_state = :array.set(mem_store, v1 + v2, state)
    new_headpos = headpos + 4
    new_instruction = get_instruction(new_headpos, new_state)

    process(new_instruction, new_headpos, new_state, nil)
  end

  defp process([opCode: 2, modes: modes], headpos, state, _input) do
    {v1, v2, mem_store} = get_params(headpos, modes, state)
    new_state = :array.set(mem_store, v1 * v2, state)
    new_headpos = headpos + 4
    new_instruction = get_instruction(new_headpos, new_state)

    process(new_instruction, new_headpos, new_state, nil)
  end

  defp process([opCode: 3, modes: _], headpos, state, input) do
    mem_store = positionMode(:write, headpos + 1, state)
    new_state = :array.set(mem_store, input, state)
    new_headpos = headpos + 2
    new_instruction = get_instruction(new_headpos, new_state)

    process(new_instruction, new_headpos, new_state, nil)
  end

  defp process([opCode: 4, modes: modes], headpos, state, _input) do
    [{_, type, op}, _, _] = modes

    output_val =
      if type == 1 do
        valueMode(headpos + 1, state)
      else
        positionMode(op, headpos + 1, state)
      end

    IO.inspect(output_val)
    new_headpos = headpos + 2
    new_instruction = get_instruction(new_headpos, state)
    process(new_instruction, new_headpos, state, output_val)
  end

  defp get_instruction(headpos, state) do
    :array.get(headpos, state) |> Test.ParseInstruction.parse()
  end

  defp get_params(headpos, modes, state) do
    [v1, v2, mem] =
      modes
      |> Enum.map(fn {step, type, op} ->
        if type == 0 do
          positionMode(op, headpos + step, state)
        else
          valueMode(headpos + step, state)
        end
      end)

    {v1, v2, mem}
  end

  defp positionMode(:read, pointer, state) do
    address = :array.get(pointer, state)
    :array.get(address, state)
  end

  defp positionMode(:write, pointer, state) do
    address = :array.get(pointer, state)
    address
  end

  defp valueMode(pointer, state) do
    :array.get(pointer, state)
  end
end
