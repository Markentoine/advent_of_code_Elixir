defmodule CrossWires do
  @moduledoc """
  Resolves day 3 of AoC 2019
  """

  def findQuickWay do
    countStepsNeeded()
    |> Enum.map(fn {x, y} -> x + y end)
    |> Enum.min()
  end

  def countStepsNeeded do
    stepsToCommons()
    |> List.zip()
  end

  def findMinDistance do
    computeDistance()
    |> Enum.min()
  end

  def computeDistance do
    commonPoints()
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
  end

  def commonPoints do
    [first, second] = pointsVisited()

    first
    |> Enum.reduce(
      [],
      fn
        {x, first_ys}, acc ->
          case Map.fetch(second, x) do
            {:ok, second_ys} ->
              diff = first_ys -- second_ys
              com = first_ys -- diff

              case(com) do
                [] ->
                  acc

                _ ->
                  Enum.map(com, fn y -> {x, y} end) ++ acc
              end

            :error ->
              acc
          end
      end
    )
  end

  def pointsVisited do
    Inputs.instructions()
    |> Enum.map(&processInstructions/1)
  end

  def stepsToCommons do
    Inputs.instructions()
    |> Enum.map(fn instr ->
      commonPoints() |> Enum.map(fn cp -> countStepsToCommon(instr, cp, {0, 0}, 0, false) end)
    end)
  end

  def countStepsToCommon(_instructions, _pointToReach, _coords, counter, true), do: counter

  def countStepsToCommon([inst | instructions], pointToReach, coords, counter, stop) do
    {newCoords, newCounter, newStop} = executeInst(inst, pointToReach, coords, counter, stop)
    countStepsToCommon(instructions, pointToReach, newCoords, newCounter, newStop)
  end

  def executeInst(_inst, _pointToReach, coords, counter, true), do: {coords, counter, true}

  def executeInst({_dir, 0}, _pointToReach, coords, counter, stop), do: {coords, counter, stop}

  def executeInst({dir, steps}, pointToReach, {x, y}, counter, stop) do
    newCoords =
      case dir do
        :R ->
          {x + 1, y}

        :L ->
          {x - 1, y}

        :U ->
          {x, y + 1}

        :D ->
          {x, y - 1}
      end

    checkGoal = newCoords == pointToReach
    newCounter = counter + 1

    newStop =
      if checkGoal do
        true
      else
        false
      end

    executeInst({dir, steps - 1}, pointToReach, newCoords, newCounter, newStop)
  end

  def processInstructions([], _coord, result), do: result

  def processInstructions([inst | instructions], coord \\ {0, 0}, result \\ %{}) do
    {newResult, newCoord} = changeCoord(inst, coord, result)
    processInstructions(instructions, newCoord, newResult)
  end

  defp changeCoord({_dir, 0}, lastCoords, points), do: {points, lastCoords}

  defp changeCoord({dir, steps}, {x, y}, points) do
    newCoords =
      case dir do
        :R ->
          {x + 1, y}

        :L ->
          {x - 1, y}

        :U ->
          {x, y + 1}

        :D ->
          {x, y - 1}
      end

    newPoints = updatePoints(newCoords, points)
    changeCoord({dir, steps - 1}, newCoords, newPoints)
  end

  defp updatePoints({x, y}, points) do
    case Map.fetch(points, x) do
      {:ok, ys} ->
        Map.update(points, x, ys, fn ys -> [y | ys] end)

      :error ->
        Map.put(points, x, [y])
    end
  end
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
