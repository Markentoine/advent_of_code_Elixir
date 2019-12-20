defmodule Ampli.AmpliApp do
  # def run do
  #  Ampli.Intcode.runProcess()
  # end
  #
  def solutionTwo do
    [0, 1, 2, 3, 4]
    |> all_permutations()
    |> Enum.map(fn perm -> perm |> amplification(0) end)
    |> Enum.max()
  end

  def solutionTwo(number) do
    number
    |> get_digits()
    |> all_permutations()
    |> Enum.map(fn perm -> perm |> amplification(0) end)
    |> Enum.max()
  end

  def amplification([], output), do: output

  def amplification([phase | rest], first_input) do
    next_input = Ampli.Intcode.runProcess(first_input, phase)
    amplification(rest, next_input)
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

# amplification  -> perndre une liste de phases en input et une première input égale à 0
# extraire le premier élément de la liste de phases, qui servira de premier input  demandée par process 3
# lancer le process avec une position du pointeur à 0
# le programme se charge et se déroule
# process 3 prend input phase
