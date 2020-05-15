defmodule OliveTest do
  use ExUnit.Case
  doctest Olive

  test "greets the world" do
    assert Olive.hello() == :world
  end
end
