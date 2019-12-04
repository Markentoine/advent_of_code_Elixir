defmodule Fuel do
  @moduledoc """
  Application to compute the fuel needed for advent od code 2019 day one.
  """

  @doc """


  ## Examples

      iex> Fuel.hello()
      :world

  """
  def total_fuel do
    fuel_needed() |> Enum.reduce(0, &+/2)
  end

  def total_recursive_fuel do
    recursive_fuel_needed() |> Enum.reduce(0, &+/2)
  end

  defp fuel_needed do
    fetch_inputs() |> Enum.map(&mass_to_fuel/1)
  end

  defp recursive_fuel_needed do
    fuel_needed() |> Enum.map(fn f -> fuel_for_fuel(f, f) end)
  end

  defp fuel_for_fuel(total, 0) do
    total
  end

  defp fuel_for_fuel(total, fuel) do
    new_Fuel = fuel |> mass_to_fuel

    updated_fuel =
      cond do
        new_Fuel <= 0 -> 0
        true -> new_Fuel
      end

    fuel_for_fuel(total + updated_fuel, updated_fuel)
  end

  defp mass_to_fuel(mass) do
    mass |> Integer.floor_div(3) |> sub2
  end

  defp fetch_inputs do
    get_path() |> File.read!() |> String.split(~r/\n/) |> Enum.map(&String.to_integer/1)
  end

  defp get_path do
    "../assets/inputs.txt" |> Path.expand(__DIR__)
  end

  defp sub2(n) do
    n - 2
  end
end

# recursive fuel
# fuel -> mass fuel -> fuel -> 0 or negative
