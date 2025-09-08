defmodule DebugInstallerConfigTest do
  use ExUnit.Case
  import Igniter.Test

  test "debug exact installer config calls" do
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
    endpoint_module = Module.concat([
      Macro.camelize(to_string(app_name)), 
      "Web", 
      "Endpoint"
    ])
    
    IO.puts("App name: #{inspect(app_name)}")
    IO.puts("Endpoint module: #{inspect(endpoint_module)}")

    # Test the first config call that's causing issues
    try do
      result1 = igniter
      |> Igniter.Project.Config.configure(
        "config/dev.exs",
        app_name,
        [endpoint_module, :live_reload, :web_console_logger], 
        true
      )
      |> puts_diff(label: "First Config Call")
      
      IO.puts("First config call succeeded!")
      
      # Test the second config call
      _result2 = result1
      |> Igniter.Project.Config.configure(
        "config/dev.exs",
        app_name, 
        [endpoint_module, :live_reload, :patterns],
        [
          ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
          ~r"priv/gettext/.*(po)$",
          ~r"lib/#{app_name}_web/(controllers|live|components)/.*(ex|heex)$"
        ]
      )
      |> puts_diff(label: "Second Config Call")
      
      IO.puts("Both config calls succeeded!")
      
    rescue
      e ->
        IO.puts("Error occurred: #{inspect(e)}")
        IO.puts("Error message: #{Exception.message(e)}")
        reraise e, __STACKTRACE__
    end
  end
end