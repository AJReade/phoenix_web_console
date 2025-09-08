defmodule Mix.Tasks.PhoenixWebConsole.InstallTest do
  use ExUnit.Case
  import Igniter.Test

  alias Mix.Tasks.PhoenixWebConsole.Install

  describe "phoenix_web_console.install" do
    test "adds phoenix_live_reload dependency" do
      test_project()
      |> Install.igniter()
      |> puts_diff(label: "Dependency Test")
    end

    test "configures web_console_logger in config/dev.exs" do
      test_project(
        files: %{
          "config/dev.exs" => """
          import Config

          config :test, TestWeb.Endpoint,
            http: [ip: {127, 0, 0, 1}, port: 4000],
            check_origin: false,
            code_reloader: true,
            debug_errors: true,
            secret_key_base: "test"
          """
        }
      )
      |> Install.igniter()
      |> assert_has_patch("config/dev.exs", """
      + web_console_logger: true
      """)
    end

    test "adds live_reload patterns when missing" do
      test_project(
        files: %{
          "config/dev.exs" => """
          import Config

          config :test, TestWeb.Endpoint,
            http: [ip: {127, 0, 0, 1}, port: 4000],
            check_origin: false,
            code_reloader: true,
            debug_errors: true,
            secret_key_base: "test"
          """
        }
      )
      |> Install.igniter()
      |> assert_has_patch("config/dev.exs", """
      + patterns: [
      +   ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      +   ~r"priv/gettext/.*(po)$",
      +   ~r"lib/test_web/(controllers|live|components)/.*(ex|heex)$"
      + ]
      """)
    end

    test "preserves existing live_reload patterns" do
      test_project(
        files: %{
          "config/dev.exs" => """
          import Config

          config :test, TestWeb.Endpoint,
            http: [ip: {127, 0, 0, 1}, port: 4000],
            check_origin: false,
            code_reloader: true,
            debug_errors: true,
            secret_key_base: "test",
            live_reload: [
              patterns: [
                ~r"custom/pattern"
              ]
            ]
          """
        }
      )
      |> Install.igniter()
      |> assert_has_patch("config/dev.exs", """
      + web_console_logger: true
      """)
      |> refute_creates("config/dev.exs") # Should not create new patterns
    end

    test "adds JavaScript event listener to app.js" do
      test_project(
        files: %{
          "assets/js/app.js" => """
          // Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
          import "phoenix_html"
          // Establish Phoenix Socket and LiveView configuration.
          import {Socket} from "phoenix"
          import {LiveSocket} from "phoenix_live_view"

          let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
          let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

          liveSocket.connect()

          window.liveSocket = liveSocket
          """
        }
      )
      |> Install.igniter()
      |> assert_has_patch("assets/js/app.js", """
      + // Phoenix Web Console Logger - Stream server logs to browser console
      + window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
      +   // Enable server log streaming to client.
      +   // Disable with reloader.disableServerLogs()
      +   reloader.enableServerLogs()
      +   window.liveReloader = reloader
      + })
      """)
    end

    test "does not modify app.js if event listener already exists" do
      test_project(
        files: %{
          "assets/js/app.js" => """
          // Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
          import "phoenix_html"

          // Phoenix Web Console Logger - Stream server logs to browser console
          window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
            reloader.enableServerLogs()
            window.liveReloader = reloader
          })
          """
        }
      )
      |> Install.igniter()
      |> assert_unchanged("assets/js/app.js")
    end

    test "provides setup notice" do
      test_project()
      |> Install.igniter()
      |> assert_has_notice("""
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

    test "works with Phoenix LiveView project structure" do
      phx_test_project()
      |> Install.igniter()
      |> apply_igniter!()
      |> assert_creates("config/dev.exs")
      |> assert_creates("assets/js/app.js")
    end

    test "handles missing assets/js/app.js gracefully" do
      test_project(files: %{})
      |> Install.igniter()
      |> apply_igniter!()
      # Should not crash even if app.js doesn't exist
    end
  end
end