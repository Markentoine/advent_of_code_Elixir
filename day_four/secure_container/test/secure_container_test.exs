defmodule SecureContainerTest do
  use ExUnit.Case
  doctest SecureContainer

  test "greets the world" do
    assert SecureContainer.hello() == :world
  end
end
