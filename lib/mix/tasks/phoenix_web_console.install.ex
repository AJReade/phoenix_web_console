defmodule Mix.Tasks.PhoenixWebConsole.Install do
  @moduledoc """
  Installs PhoenixWebConsole in a Phoenix application.

  This task automatically:
  - Ensures phoenix_live_reload dependency is present
  - Updates config/dev.exs to enable web_console_logger
  - Modifies assets/js/app.js to enable server log reception
  - Provides setup confirmation and instructions

  ## Usage

  From GitHub (before Hex publication):

      mix igniter.install repo.phoenix_web_console AJReade/phoenix_web_console

  From Hex (once published):

      mix igniter.install phoenix_web_console

  Or run directly:

      mix phoenix_web_console.install
  """

  use Igniter.Mix.Task

  @impl Igniter.Mix.Task
  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      group: :igniter,
      example: "mix igniter.install phoenix_web_console",
      schema: []
    }
  end

  @impl Igniter.Mix.Task
  def igniter(igniter) do
    igniter
    |> ensure_phoenix_live_reload_dependency()
    |> update_dev_config()
    |> update_app_js()
    |> add_setup_instructions()
  end

  defp ensure_phoenix_live_reload_dependency(igniter) do
    # Note: The phoenix_web_console dependency is automatically added by Igniter
    # We only need to ensure phoenix_live_reload is present
    Igniter.Project.Deps.add_dep(igniter, {:phoenix_live_reload, "~> 1.5"}, type: :dev)
  end

  defp update_dev_config(igniter) do
    config_path = "config/dev.exs"

    Igniter.update_file(igniter, config_path, fn content ->
      if String.contains?(content, "web_console_logger") do
        # Already configured, don't modify
        content
      else
        # Add web_console_logger configuration
        updated_content = String.replace(
          content,
          ~r/(live_reload:\s*\[)/,
          "\\1\n    web_console_logger: true,"
        )

        # If live_reload config doesn't exist, add it
        if String.contains?(updated_content, "live_reload:") do
          updated_content
        else
          # Find the endpoint config and add live_reload
          # Extract app name from existing config if possible
          app_name = case Regex.run(~r/config\s+:([^,]+),/, content) do
            [_, app] -> String.trim(app)
            _ -> "my_app"
          end

          String.replace(
            content,
            ~r/(config\s+:[^,]+,\s+[^,]+Endpoint,\s*\[)/,
            "\\1\n  live_reload: [\n    web_console_logger: true,\n    patterns: [\n      ~r\"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$\",\n      ~r\"priv/gettext/.*(po)$\",\n      ~r\"lib/#{app_name}_web/(controllers|live|components)/.*(ex|heex)$\"\n    ]\n  ],"
          )
        end
      end
    end)
  end

  defp update_app_js(igniter) do
    app_js_path = "assets/js/app.js"

    Igniter.update_file(igniter, app_js_path, fn content ->
      if String.contains?(content, "phx:live_reload:attached") do
        # Event listener already exists, don't modify
        content
      else
        # Add the event listener
        content <> """

// Phoenix Web Console Logger - Stream server logs to browser console
window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
  // Enable server log streaming to client.
  // Disable with reloader.disableServerLogs()
  reloader.enableServerLogs()
  window.liveReloader = reloader
})
"""
      end
    end)
  end

  defp add_setup_instructions(igniter) do
    Igniter.add_notice(igniter, """
    PhoenixWebConsole has been installed successfully!

    ✅ Updated config/dev.exs to enable web_console_logger
    ✅ Updated assets/js/app.js to enable server log reception
    ✅ Ensured phoenix_live_reload ~> 1.5 dependency

    Server logs will now appear in your browser's web console during development.
    Start your Phoenix server with `mix phx.server` and open your browser's
    developer tools to see server logs alongside client logs.

    To disable server logs, call `window.liveReloader.disableServerLogs()` in
    your browser console.
    """)
  end
end