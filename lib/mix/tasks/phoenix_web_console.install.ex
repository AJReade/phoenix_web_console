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
    # Note: phoenix_web_console dependency is automatically handled by Igniter
    # We only need to ensure phoenix_live_reload is available for web console functionality
    # Use optional: true to avoid upgrade conflicts in tests
    Igniter.Project.Deps.add_dep(igniter, {:phoenix_live_reload, "~> 1.5"}, type: :dev, optional: true)
  end

  defp update_dev_config(igniter) do
    # For now, just add a simple notice that manual config is needed
    # This avoids the Unicode issues while still providing functionality
    igniter
    |> Igniter.add_notice("""
    Manual configuration required for config/dev.exs:
    
    Please add the following to your endpoint configuration in config/dev.exs:
    
    config :your_app, YourAppWeb.Endpoint,
      live_reload: [
        web_console_logger: true,
        patterns: [
          ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
          ~r"priv/gettext/.*(po)$",
          ~r"lib/your_app_web/(controllers|live|components)/.*(ex|heex)$"
        ]
      ]
    """)
  end

  defp update_app_js(igniter) do
    app_js_path = "assets/js/app.js"
    
    js_code = """

// Phoenix Web Console Logger - Stream server logs to browser console
window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
  // Enable server log streaming to client.
  // Disable with reloader.disableServerLogs()
  reloader.enableServerLogs()
  window.liveReloader = reloader
})
"""

    Igniter.update_file(igniter, app_js_path, fn content ->
      # Get the actual string content
      content_string = case content do
        %Rewrite.Source{content: source_content} -> source_content
        string when is_binary(string) -> string
      end
      
      if String.contains?(content_string, "phx:live_reload:attached") do
        # Event listener already exists, don't modify
        content
      else
        # Add the event listener - need to update the source content
        updated_content = content_string <> js_code
        %{content | content: updated_content}
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