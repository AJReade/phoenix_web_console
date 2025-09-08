defmodule InstallerTest do
  use ExUnit.Case
  import Igniter.Test

  alias Mix.Tasks.PhoenixWebConsole.Install

  test "installer runs without unicode errors" do
    igniter = test_project(
      files: %{
        "config/dev.exs" => """
        import Config

        config :test, TestWeb.Endpoint,
          http: [ip: {127, 0, 0, 1}, port: 4000],
          check_origin: false,
          code_reloader: true,
          debug_errors: true,
          secret_key_base: "test"
        """,
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

    # This should complete without Unicode errors
    result = igniter
    |> Install.igniter()
    |> puts_diff(label: "Full Installer Test")

    IO.puts("Installer test completed successfully!")
  end
end