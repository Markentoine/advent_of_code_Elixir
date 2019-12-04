defmodule ProgramAlarm.RetrieveState do
  def restore_state do
    inputs = ProgramAlarm.FetchInputs.array_inputs()
    new_inputs = :array.set(1, 12, inputs)
    :array.set(2, 2, new_inputs)
  end
end
