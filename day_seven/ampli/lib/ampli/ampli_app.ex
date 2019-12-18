defmodule Ampli.AmpliApp do
  def run do
    Ampli.Intcode.runProcess()
  end

  def all_permutations([a, b]), do: [[a, b], [b, a]]

  def all_permutations(list) do
    list
    |> Enum.flat_map(fn d ->
      all_permutations(Enum.filter(list, fn n -> n != d end))
      |> Enum.map(fn perm -> [d | perm] end)
    end)
  end

  # PRIVATE
  defp get_digits(n) do
    n |> Integer.to_string() |> Enum.map(&String.to_integer/1)
  end
end

# all permutations of n elements
# perm[head | tail ] -> a * perm[tail]
# [1, 2, 3] -> 1 [2, 3] -> 2, 3 -> 1, 2, 3
#                       -> 3, 2 -> 1, 3, 2
#           -> 2 [1, 3] -> 1, 3 -> 2, 1, 3
#                       -> 3, 1 -> 2, 3, 1
#           -> 3 [1, 2] -> 1, 2 -> 3, 1, 2
#                       -> 2, 1 -> 3, 2, 1
# List -> pour tous les éléments de la liste prendre le reste de la liste et appliquer
# récursivement.
# quand la liste n'est plus constituée que d'un seule chiffre, renvoyer ce chiffre et
# concaténer les listes.
# list -> list de list
# perm(list) -> list enum map -> list n ++ perm(list - n)
# perm(list one element) -> return element
