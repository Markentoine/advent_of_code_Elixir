defmodule Ampli.Intcode do
  def runProcess(first_input, phase) do
    state = Ampli.Program.get_program()
    instructions = :array.get(0, state) |> Ampli.ParseProgram.parse()
    process(instructions, 0, state, input: first_input, phases_input: phase, phase: true)
  end

  # PRIVATE

  defp process([opCode: 99, modes: _], _headpos, _state,
         input: output_val,
         phases_input: _phases_input,
         phase: _
       ) do
    output_val
  end

  defp process([opCode: 1, modes: modes], headpos, state, datas) do
    {v1, v2, mem_store} = get_params(headpos, modes, state)
    new_state = :array.set(mem_store, v1 + v2, state)
    new_headpos = headpos + 4
    new_instruction = get_instruction(new_headpos, new_state)

    process(new_instruction, new_headpos, new_state, datas)
  end

  defp process([opCode: 2, modes: modes], headpos, state, datas) do
    {v1, v2, mem_store} = get_params(headpos, modes, state)
    new_state = :array.set(mem_store, v1 * v2, state)
    new_headpos = headpos + 4
    new_instruction = get_instruction(new_headpos, new_state)

    process(new_instruction, new_headpos, new_state, datas)
  end

  defp process([opCode: 3, modes: _], headpos, state,
         input: current_input,
         phases_input: phases_input,
         phase: false
       ) do
    mem_store = positionMode(:write, headpos + 1, state)
    new_state = :array.set(mem_store, current_input, state)
    new_headpos = headpos + 2
    new_instruction = get_instruction(new_headpos, new_state)

    process(new_instruction, new_headpos, new_state,
      input: current_input,
      phases_input: phases_input,
      phase: true
    )
  end

  defp process([opCode: 3, modes: _], headpos, state,
         input: input,
         phases_input: phases_input,
         phase: true
       ) do
    mem_store = positionMode(:write, headpos + 1, state)
    new_state = :array.set(mem_store, phases_input, state)
    new_headpos = headpos + 2
    new_instruction = get_instruction(new_headpos, new_state)

    process(new_instruction, new_headpos, new_state,
      input: input,
      phases_input: phases_input,
      phase: false
    )
  end

  defp process([opCode: 4, modes: modes], headpos, state,
         input: _input,
         phases_input: phases_input,
         phase: phase
       ) do
    [{_, type, op}, _, _] = modes

    output_val =
      if type == 1 do
        valueMode(headpos + 1, state)
      else
        positionMode(op, headpos + 1, state)
      end

    # IO.inspect(output_val)
    new_input = output_val
    new_headpos = headpos + 2
    new_instruction = get_instruction(new_headpos, state)

    process(new_instruction, new_headpos, state,
      input: new_input,
      phases_input: phases_input,
      phase: phase
    )
  end

  defp process([opCode: 5, modes: modes], headpos, state, datas) do
    {param1, param2, _} = get_params(headpos, modes, state)

    new_headpos =
      if param1 !== 0 do
        param2
      else
        headpos + 3
      end

    new_instruction = get_instruction(new_headpos, state)

    process(new_instruction, new_headpos, state, datas)
  end

  defp process([opCode: 6, modes: modes], headpos, state, datas) do
    {param1, param2, _} = get_params(headpos, modes, state)

    new_headpos =
      if param1 == 0 do
        param2
      else
        headpos + 3
      end

    new_instruction = get_instruction(new_headpos, state)

    process(new_instruction, new_headpos, state, datas)
  end

  defp process([opCode: 7, modes: modes], headpos, state, datas) do
    {param1, param2, param3} = get_params(headpos, modes, state)

    new_state =
      if param1 < param2 do
        :array.set(param3, 1, state)
      else
        :array.set(param3, 0, state)
      end

    new_headpos = headpos + 4
    new_instruction = get_instruction(headpos + 4, new_state)
    process(new_instruction, new_headpos, new_state, datas)
  end

  defp process([opCode: 8, modes: modes], headpos, state, datas) do
    {param1, param2, param3} = get_params(headpos, modes, state)

    new_state =
      if param1 == param2 do
        :array.set(param3, 1, state)
      else
        :array.set(param3, 0, state)
      end

    new_headpos = headpos + 4
    new_instruction = get_instruction(headpos + 4, new_state)
    process(new_instruction, new_headpos, new_state, datas)
  end

  # HELPERS

  defp get_instruction(headpos, state) do
    :array.get(headpos, state) |> Ampli.ParseProgram.parse()
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

  # MODES

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
