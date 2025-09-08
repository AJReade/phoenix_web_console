defmodule PhoenixWebConsole.WebConsoleLogger do
  @moduledoc """
  A logger handler that broadcasts log messages to Phoenix channels for display
  in the browser's web console during development.

  This module implements the Erlang `:logger` handler behavior and uses
  Elixir's Registry for local pubsub to notify live reload channels
  whenever a new message is logged.
  """

  @registry PhoenixWebConsole.WebConsoleLoggerRegistry

  @doc """
  Attaches the web console logger handler to the Erlang logger system.
  """
  def attach_logger do
    :ok =
      :logger.add_handler(__MODULE__, __MODULE__, %{
        formatter: Logger.default_formatter(colors: [enabled: false])
      })
  end

  @doc """
  Child spec for the Registry that manages log subscribers.
  """
  def child_spec(_args) do
    Registry.child_spec(name: @registry, keys: :duplicate)
  end

  @doc """
  Subscribes a process to receive log events with the given prefix.
  """
  def subscribe(prefix) do
    {:ok, _} = Registry.register(@registry, :all, prefix)
    :ok
  end

  @doc """
  Erlang/OTP log handler callback.

  This function is called by the Erlang logger for each log event.
  It formats the message and broadcasts it to all registered subscribers.
  """
  def log(%{meta: meta, level: level} = event, config) do
    %{formatter: {formatter_mod, formatter_config}} = config
    msg = IO.iodata_to_binary(formatter_mod.format(event, formatter_config))

    Registry.dispatch(@registry, :all, fn entries ->
      event = %{level: level, msg: msg, file: meta[:file], line: meta[:line]}
      for {pid, prefix} <- entries, do: send(pid, {prefix, event})
    end)
  end
end