defmodule AmpliTest do
  use ExUnit.Case
  doctest Ampli

  test "greets the world" do
    assert Ampli.hello() == :world
  end
end
