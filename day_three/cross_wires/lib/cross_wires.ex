defmodule CrossWires do
  @moduledoc """
  Resolves day 3 of AoC 2019
  """
end

# analyse du probleme
# inputs -> deux strings constituées de paires lettre/chiffre qui représentent
# la lettre : une direction, RL, rigth left, UD, up down
# le chiffre : le nombre de pas dans cette direction
# chaque string a la meme origine
# déterminer les croisements entre les strings
# croisement? arrivent sur meme coordonée
# une fois ces croisements déterminés, 
# trouver celui qui est à la distance la plus proche de l'origine
# la distance : Manhattan distance (somme des coordonées la plus faible)

# idee
# obtenir les coordonnées de tous les points touchés
# comparer ces coordonnées et relever les points identiques
# trouver celui qui a la somme des coordonnées la plus petite.

# une fonction Up -> incremente +1 y
# fonction Down -> décrémente -1 y
# fonction Right -> incrémente +1 x
# fonction Left -> décrémente -1 x
# (R9) -> 9 * application  de la fonction Right
# coordonées de départ (0, 0)

# process inputs : string -> split (,) -> list d'instructions
# process coord : coord -> list d'instructions -> list coordonnées
# recursive sur la list d'entrée
# parse instruction -> string -> tuple {function, number}
# process instruction: coordonnées, parsedInstruction -> coordonnées
# quand number à zéro -> retourne les coordonnées 
# les passe à process coord avec le tail de la liste précédemment donnée

# une fois les deux strings transformées en deux listes de coordonnées
# recherche des coordonnées communes dans les deux listes
# nouvelle liste de coordonnées qui représentent les points de croisements

# calcul des manhattan distance de chaque coordonnées par map
# sorting de cette nouvelle liste
# retour de la valeur en 0
