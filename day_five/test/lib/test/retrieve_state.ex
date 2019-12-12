defmodule Test.RetrieveState do
  def restore_state(noun, verb) do
    inputs = Test.FetchInputs.array_inputs()
    new_inputs = :array.set(1, noun, inputs)
    :array.set(2, verb, new_inputs)
  end
end
