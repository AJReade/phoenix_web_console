defmodule PhoenixWebConsole do
  @moduledoc """
  PhoenixWebConsole provides easy installation and setup of server log
  streaming to the browser console for Phoenix applications.

  This library enables developers to see server logs directly in their
  browser's web console during development, making debugging significantly
  easier by co-locating server and client logs.

  ## Installation

  Install via Igniter for automatic setup:

      mix igniter.install phoenix_web_console

  ## Manual Setup

  If you prefer manual setup:

  1. Add the dependency to your `mix.exs`:

      {:phoenix_web_console, "~> 0.1.0"}

  2. Enable web console logging in `config/dev.exs`:

      config :my_app, MyAppWeb.Endpoint,
        live_reload: [
          web_console_logger: true,
          patterns: [
            ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
            ~r"priv/gettext/.*(po)$",
            ~r"lib/my_app_web/(controllers|live|components)/.*(ex|heex)$"
          ]
        ]

  3. Enable server logs in your `assets/js/app.js`:

      window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
        reloader.enableServerLogs()
        window.liveReloader = reloader
      })

  ## Requirements

  - Phoenix LiveView application
  - phoenix_live_reload ~> 1.5
  - Development environment only
  """

  alias PhoenixWebConsole.WebConsoleLogger

  @doc """
  Sets up the web console logger for development.

  This function should typically be called automatically by the Igniter
  installer, but can be used for manual setup if needed.
  """
  def setup do
    WebConsoleLogger.attach_logger()
  end

  @doc """
  Gets the child spec for the web console logger registry.

  Add this to your application's supervision tree in development:

      children = [
        # ... other children
        PhoenixWebConsole.child_spec([])
      ]
  """
  def child_spec(args) do
    WebConsoleLogger.child_spec(args)
  end
end
