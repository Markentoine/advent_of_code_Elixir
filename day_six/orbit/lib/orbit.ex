defmodule Orbit do
  @moduledoc """
  Day Six AoC 2019
  """
  def runSolutionTwo do
    {vertices, _} = define_vertices()
    matrix = define_edges(vertices)
    you = Map.fetch!(vertices, "YOU")
    santa = Map.fetch!(vertices, "SAN")
    com = Map.fetch!(vertices, "COM")
    {parentSanta, parentYou} = retrieve_both_parents(santa, you, matrix)

    common_parent =
      retrieve_common_parent(
        [parentSanta: parentSanta, parentYou: parentYou, com: com],
        [],
        [],
        matrix
      )

    count_edges(common_parent, parentYou, 0, matrix) +
      count_edges(common_parent, parentSanta, 0, matrix)
  end

  def runSolutionOne do
    {vertices, _} = define_vertices()
    matrix = define_edges(vertices)
    com = Map.fetch!(vertices, "COM")
    countTotalEdges(com, matrix, 0)
  end

  # PRIVATE
  defp count_edges(:stop, counter), do: counter

  defp count_edges(source, destination, counter, matrix) do
    if destination == source do
      count_edges(:stop, counter)
    else
      count_edges(source, get_parents(destination, matrix), counter + 1, matrix)
    end
  end

  defp retrieve_common_parent({:stop, commonAncestor}, _ancestorsSanta, _ancestorsYou, _matrix),
    do: commonAncestor

  defp retrieve_common_parent(
         [parentSanta: parentSanta, parentYou: parentYou, com: com],
         ancestorsSanta,
         ancestorsYou,
         matrix
       ) do
    ancestorSanta =
      if parentSanta != com do
        get_parents(parentSanta, matrix)
      else
        com
      end

    ancestorYou =
      if parentYou != com do
        get_parents(parentYou, matrix)
      else
        com
      end

    case ancestorSanta != com && Enum.member?(ancestorsYou, Integer.to_string(ancestorSanta)) do
      true ->
        retrieve_common_parent({:stop, ancestorSanta}, ancestorsSanta, ancestorsYou, matrix)

      false ->
        new_ancestorsSanta =
          if ancestorSanta == com do
            ancestorsSanta
          else
            [Integer.to_string(ancestorSanta) | ancestorsSanta]
          end

        case ancestorYou != com && Enum.member?(ancestorsSanta, Integer.to_string(ancestorYou)) do
          true ->
            retrieve_common_parent({:stop, ancestorYou}, ancestorsSanta, ancestorsYou, matrix)

          false ->
            new_ancestorsYou =
              if ancestorYou == com do
                ancestorsYou
              else
                [Integer.to_string(ancestorYou) | ancestorsYou]
              end

            retrieve_common_parent(
              [parentSanta: ancestorSanta, parentYou: ancestorYou, com: com],
              new_ancestorsSanta,
              new_ancestorsYou,
              matrix
            )
        end
    end
  end

  defp retrieve_both_parents(a, b, matrix) do
    parentA = get_parents(a, matrix)
    parentB = get_parents(b, matrix)
    {parentA, parentB}
  end

  defp get_parents(child, matrix) do
    :array.foldr(
      fn idx, row, result ->
        if controlChildrenPresence(row, child) do
          result = idx
          result
        else
          result
        end
      end,
      nil,
      matrix
    )
  end

  def controlChildrenPresence(row, children) do
    :array.get(children, row) == 1
  end

  defp countTotalEdges(:bottom, _matrix, count), do: count

  defp countTotalEdges(entryPoint, matrix, count) do
    #  
    links =
      :array.get(entryPoint, matrix)
      |> :array.to_orddict()
      |> Enum.filter(fn {_index, value} -> value === 1 end)
      |> Enum.map(fn {index, _value} -> index end)

    # IO.inspect(links)

    if Enum.count(links) == 0 do
      countTotalEdges(:bottom, matrix, count)
    else
      count +
        Enum.reduce(links, 0, fn link, acc ->
          acc + countTotalEdges(link, matrix, count + 1)
        end)
    end
  end

  defp define_edges(vertices) do
    matrix = get_dimension(vertices) |> build_matrix()

    FetchInputs.parse_inputs()
    |> populate_edges(matrix, vertices)
  end

  defp populate_edges([], matrix, _vertices), do: matrix

  defp populate_edges(datas, matrix, vertices) do
    [data | rest] = datas

    [parent, child] = data |> get_coord(vertices)
    row = :array.get(parent, matrix)
    columnUpdated = :array.set(child, 1, row)
    new_matrix = :array.set(parent, columnUpdated, matrix)
    populate_edges(rest, new_matrix, vertices)
  end

  defp get_coord(data, vertices) do
    data |> String.split(~r/\)/, trim: true) |> Enum.map(fn v -> Map.get(vertices, v) end)
  end

  defp build_matrix(dimension) do
    column = :array.new(dimension, default: 0)
    :array.new(dimension, default: column)
  end

  defp get_dimension(vertices) do
    vertices |> Map.keys() |> Enum.count()
  end

  defp define_vertices do
    FetchInputs.parse_inputs()
    |> Enum.reduce({%{}, count: 0}, fn data, result ->
      listVertices = data |> String.split(~r/\)/, trim: true)
      updateVertices(listVertices, result)
    end)

    # |> Map.keys()
    # |> :array.from_list()
  end

  defp updateVertices([], result), do: result

  defp updateVertices(listVertices, {vertices, count: count}) do
    [v | rest] = listVertices

    case Map.fetch(vertices, v) do
      :error ->
        new_vertices = Map.put(vertices, v, count)
        updateVertices(rest, {new_vertices, count: count + 1})

      _ ->
        updateVertices(rest, {vertices, count: count})
    end
  end
end

# --- Day 6: Universal Orbit Map ---
# You've landed at the Universal Orbit Map facility on Mercury. Because navigation in space often involves transferring between orbits, the orbit maps here are useful for finding efficient routes between, for example, you and Santa. You download a map of the local orbits (your puzzle input).
# 
# Except for the universal Center of Mass (COM), every object in space is in orbit around exactly one other object. An orbit looks roughly like this:
# 
#                   \
#                    \
#                     |
#                     |
# AAA--> o            o <--BBB
#                     |
#                     |
#                    /
#                   /
# In this diagram, the object BBB is in orbit around AAA. The path that BBB takes around AAA (drawn with lines) is only partly shown. In the map data, this orbital relationship is written AAA)BBB, which means "BBB is in orbit around AAA".
# 
# Before you use your map data to plot a course, you need to make sure it wasn't corrupted during the download. To verify maps, the Universal Orbit Map facility uses orbit count checksums - the total number of direct orbits (like the one shown above) and indirect orbits.
# 
# Whenever A orbits B and B orbits C, then A indirectly orbits C. This chain can be any number of objects long: if A orbits B, B orbits C, and C orbits D, then A indirectly orbits D.
# 
# For example, suppose you have the following map:
# 
# COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# utilisation d'une matrice pour notere d'un 1 les edges
# [[][][][][]]
# 
# Visually, the above map of orbits looks like this:
# 
#         G - H       J - K - L
#        /           /
# COM - B - C - D - E - F
#                \
#                 I
# In this visual representation, when two objects are connected by a line, the one on the right directly orbits the one on the left.
# 
# Here, we can count the total number of orbits as follows:
# 
# D directly orbits C and indirectly orbits B and COM, a total of 3 orbits.
# L directly orbits K and indirectly orbits J, E, D, C, B, and COM, a total of 7 orbits.
# COM orbits nothing.
# The total number of direct and indirect orbits in this example is 42.
# 
# What is the total number of direct and indirect orbits in your map data?

# inputs list of chars : AA)BB -> la parenthèse sépare deux données et marque le lien entre ces deux données, 
# la seconde étant fille de la première
# chaque donnée peut être considérée comme un noeud 
# construires un array contenant tous les vertices (noeuds) -> construire d'abord une map pour éviter les duplications, sortir 
# les keys
