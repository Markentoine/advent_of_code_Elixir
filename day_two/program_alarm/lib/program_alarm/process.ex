defmodule ProgramAlarm.Process do
  def find_solution_one do
    :array.get(0, start(12, 2))
  end

  def find_solution_two(objective) do
    search(nil, objective, noun: 1, verb: 1)
  end

  def search(result, objective, noun: noun, verb: verb) when result == objective do
    [noun: noun, verb: verb]
  end

  def search(_result, _objective, noun: 99, verb: 99) do
    {:error, :not_found}
  end

  def search(_result, objective, noun: noun, verb: 99) do
    new_result = :array.get(0, start(noun + 1, 1))
    search(new_result, objective, noun: noun + 1, verb: 1)
  end

  def search(nil, objective, noun: noun, verb: verb) do
    new_result = :array.get(0, start(noun, verb))
    search(new_result, objective, noun: 1, verb: 1)
  end

  def search(_result, objective, noun: noun, verb: verb) do
    new_result = :array.get(0, start(noun, verb + 1))
    search(new_result, objective, noun: noun, verb: verb + 1)
  end

  def start(noun, verb) do
    general_process(0, ProgramAlarm.RetrieveState.restore_state(noun, verb))
  end

  def general_process(headpos \\ 0, state) do
    head_value = :array.get(headpos, state)
    process(head_value, headpos, state)
  end

  # PRIVATE

  defp process(99, _headpos, state), do: state

  defp process(1, headpos, state) do
    {v1, v2} = get_values(headpos, state)
    mem_store = :array.get(headpos + 3, state)
    new_state = :array.set(mem_store, v1 + v2, state)
    new_headpos = headpos + 4
    new_head_value = :array.get(new_headpos, new_state)
    process(new_head_value, new_headpos, new_state)
  end

  defp process(2, headpos, state) do
    {v1, v2} = get_values(headpos, state)
    mem_store = :array.get(headpos + 3, state)
    new_state = :array.set(mem_store, v1 * v2, state)
    new_headpos = headpos + 4
    new_head_value = :array.get(new_headpos, new_state)
    process(new_head_value, new_headpos, new_state)
  end

  defp get_values(headpos, state) do
    pv1 = :array.get(headpos + 1, state)
    pv2 = :array.get(headpos + 2, state)
    v1 = :array.get(pv1, state)
    v2 = :array.get(pv2, state)
    {v1, v2}
  end
end
