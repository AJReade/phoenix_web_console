defmodule RegexConfigTest do
  use ExUnit.Case
  import Igniter.Test

  test "proper way to add regex patterns via Igniter config" do
    igniter = test_project(
      files: %{
        "config/dev.exs" => """
        import Config

        config :test, TestWeb.Endpoint,
          http: [ip: {127, 0, 0, 1}, port: 4000],
          live_reload: [
            web_console_logger: true
          ]
        """
      }
    )

    app_name = Igniter.Project.Application.app_name(igniter)
    endpoint_module = Module.concat([Macro.camelize(to_string(app_name)), "Web", "Endpoint"])

    # Test different approaches to adding regex patterns
    
    # Approach 1: Try with literal patterns (not interpolated)
    try do
      _result1 = igniter
      |> Igniter.Project.Config.configure(
        "config/dev.exs",
        app_name, 
        [endpoint_module, :live_reload, :patterns],
        [
          ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
          ~r"priv/gettext/.*(po)$",
          ~r"lib/test_web/(controllers|live|components)/.*(ex|heex)$"
        ]
      )
      |> puts_diff(label: "Literal Regex Patterns")
      
      IO.puts("✅ Literal regex patterns worked!")
    rescue
      e ->
        IO.puts("❌ Literal regex patterns failed: #{Exception.message(e)}")
    end

    # Approach 2: Try with string-based patterns
    try do
      _result2 = igniter
      |> Igniter.Project.Config.configure(
        "config/dev.exs",
        app_name, 
        [endpoint_module, :live_reload, :patterns],
        [
          "~r\"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$\"",
          "~r\"priv/gettext/.*(po)$\"", 
          "~r\"lib/test_web/(controllers|live|components)/.*(ex|heex)$\""
        ]
      )
      |> puts_diff(label: "String-based Patterns")
      
      IO.puts("✅ String-based patterns worked!")
    rescue
      e ->
        IO.puts("❌ String-based patterns failed: #{Exception.message(e)}")
    end
  end
end