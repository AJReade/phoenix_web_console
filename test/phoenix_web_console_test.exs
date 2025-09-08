defmodule PhoenixWebConsoleTest do
  use ExUnit.Case
  doctest PhoenixWebConsole

  alias PhoenixWebConsole.WebConsoleLogger

  test "can create child spec" do
    child_spec = PhoenixWebConsole.child_spec([])
    assert child_spec.id == PhoenixWebConsole.WebConsoleLoggerRegistry
    assert child_spec.start == {Registry, :start_link, [[name: PhoenixWebConsole.WebConsoleLoggerRegistry, keys: :duplicate]]}
  end

  test "web console logger can subscribe" do
    {:ok, _pid} = start_supervised(PhoenixWebConsole.child_spec([]))
    assert :ok == WebConsoleLogger.subscribe("test_prefix")
  end
end
