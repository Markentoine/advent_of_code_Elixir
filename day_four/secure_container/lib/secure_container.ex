defmodule SecureContainer do
  @moduledoc """
  Solution: Day Four AoC 2019
  """
  # 
  #   --- Day 4: Secure Container ---
  # You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.
  # 
  # However, they do remember a few key facts about the password:
  # 
  # It is a six-digit number.
  # The value is within the range given in your puzzle input.
  # Two adjacent digits are the same (like 22 in 122345).
  # Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
  # Other than the range rule, the following are true:
  # 
  # 111111 meets these criteria (double 11, never decreases).
  # 223450 does not meet these criteria (decreasing pair of digits 50).
  # 123789 does not meet these criteria (no double).
  # How many different passwords within the range given in your puzzle input meet these criteria?
  # 
  # Your puzzle input is 109165-576723.
  # 10 no -> 11 -> 111111 min
  # match 11, 22 33 44 55 66 77 88 99 
  # no 0

  #  --- Part Two ---
  # n Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.
  # 
  # iven this additional criterion, but still ignoring the range rule, the following are now true:
  # 
  # 12233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
  # 23444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
  # 11122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
  # ow many different passwords within the range given in your puzzle input meet all of the criteria?

  def solutionOne do
    filteringSolutionOne() |> Enum.count()
  end

  def solutionTwo do
    filteringSolutionTwo()
  end

  def filteringSolutionTwo do
    filteringSolutionOne()
    |> Enum.filter(&notContain4IdDigits/1)
    |> Enum.filter(&notContain4DigAndDiffNum/1)
    |> Enum.filter(&notContain2GroupsOf3IdNum/1)
    |> Enum.filter(&otherCases/1)
    |> Enum.count()
  end

  def filteringSolutionOne do
    listNumbers(109_165, 576_723)
    |> Enum.filter(&containTwoConsSameDigit/1)
    |> Enum.filter(&containNoZero/1)
    |> Enum.filter(&noRegressionFirstTWo/1)
    |> Enum.filter(&noRegressionInside/1)
  end

  def otherCases(n) do
    strN = Integer.to_string(n)

    !(Regex.match?(~r/(\d)(?!\1)(\d)(?!\2)\d(\d)\3{2}/, strN) ||
        Regex.match?(~r/(\d)(?!\1)\d(\d)\2{2}\d/, strN) ||
        Regex.match?(~r/\d(\d)\1{2}(\d)(?!\2)\d/, strN) ||
        Regex.match?(~r/(\d)\1{2}(\d)(?!\2)(\d)(?!\3)\d/, strN))
  end

  def notContain2GroupsOf3IdNum(n) do
    !Regex.match?(~r/(\d)\1{2}(\d)\2{2}/, Integer.to_string(n))
  end

  def notContain4DigAndDiffNum(n) do
    !Regex.match?(~r/(\d)(?!\1)\d(\d)\2{3}|(\d)\3{3}(\d)(?!\4)/, Integer.to_string(n))
  end

  def notContain4IdDigits(n) do
    !Regex.match?(~r/(\d)\1{4,}/, Integer.to_string(n))
  end

  def listNumbers(x, y), do: x..y

  def containTwoConsSameDigit(n) do
    Regex.match?(~r/(\d)\1/, Integer.to_string(n))
  end

  def containNoZero(n) do
    !Regex.match?(~r/0/, Integer.to_string(n))
  end

  def noRegressionInside(n) do
    [first, second, third, fourth, fifth, sixth] =
      Integer.to_string(n)
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    first - second <= 0 &&
      second - third <= 0 &&
      third - fourth <= 0 &&
      fourth - fifth <= 0 &&
      fifth - sixth <= 0
  end

  def noRegressionFirstTWo(n) do
    [first, second | _rest] =
      Integer.to_string(n)
      |> String.split("", trim: true)

    String.to_integer(second) >= String.to_integer(first)
  end
end

#  12234  -1 0 -1 -1 -1  
#  22345
