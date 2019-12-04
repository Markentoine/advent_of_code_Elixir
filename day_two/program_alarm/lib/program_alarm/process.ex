defmodule ProgramAlarm.Process do
  def find_solution_one do
    :array.get(0, start())
  end

  def start do
    general_process(0, ProgramAlarm.RetrieveState.restore_state())
  end

  def general_process(headpos \\ 0, state) do
    head_value = :array.get(headpos, state)
    process(head_value, headpos, state)
  end

  # PRIVATE

  defp process(99, _headpos, state), do: state

  defp process(1, headpos, state) do
    pv1 = :array.get(headpos + 1, state)
    pv2 = :array.get(headpos + 2, state)
    v1 = :array.get(pv1, state)
    v2 = :array.get(pv2, state)
    mem_store = :array.get(headpos + 3, state)
    new_state = :array.set(mem_store, v1 + v2, state)
    new_headpos = headpos + 4
    new_head_value = :array.get(new_headpos, new_state)
    process(new_head_value, new_headpos, new_state)
  end

  defp process(2, headpos, state) do
    pv1 = :array.get(headpos + 1, state)
    pv2 = :array.get(headpos + 2, state)
    v1 = :array.get(pv1, state)
    v2 = :array.get(pv2, state)
    mem_store = :array.get(headpos + 3, state)
    new_state = :array.set(mem_store, v1 * v2, state)
    new_headpos = headpos + 4
    new_head_value = :array.get(new_headpos, new_state)
    process(new_head_value, new_headpos, new_state)
  end
end
