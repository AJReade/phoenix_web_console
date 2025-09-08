defmodule ConfigTest do
  use ExUnit.Case
  import Igniter.Test

  test "config editing with proper Igniter functions" do
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
        """
      }
    )

    app_name = Igniter.Project.Application.app_name(igniter)
    IO.puts("App name: #{inspect(app_name)}")
    
    # Test the exact pattern from our installer
    endpoint_module = Module.concat([
      Macro.camelize(to_string(app_name)), 
      "Web", 
      "Endpoint"
    ])
    
    IO.puts("Endpoint module: #{inspect(endpoint_module)}")

    # Test configuring web_console_logger
    result = igniter
    |> Igniter.Project.Config.configure(
      "config/dev.exs",
      app_name,
      [endpoint_module, :live_reload, :web_console_logger], 
      true
    )
    |> puts_diff(label: "Config Test")

    IO.puts("Config test completed successfully!")
  end

  test "config editing with existing live_reload" do
    igniter = test_project(
      files: %{
        "config/dev.exs" => """
        import Config

        config :test, TestWeb.Endpoint,
          http: [ip: {127, 0, 0, 1}, port: 4000],
          live_reload: [
            patterns: [
              ~r"custom/pattern"
            ]
          ]
        """
      }
    )

    app_name = Igniter.Project.Application.app_name(igniter)
    endpoint_module = Module.concat([Macro.camelize(to_string(app_name)), "Web", "Endpoint"])

    # Test adding web_console_logger to existing live_reload config
    _result = igniter
    |> Igniter.Project.Config.configure(
      "config/dev.exs",
      app_name,
      [endpoint_module, :live_reload, :web_console_logger], 
      true
    )
    |> puts_diff(label: "Existing Config Test")

    IO.puts("Existing config test completed!")
  end
end