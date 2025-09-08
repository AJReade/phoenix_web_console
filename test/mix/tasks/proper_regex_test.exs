defmodule ProperRegexTest do
  use ExUnit.Case
  import Igniter.Test

  test "proper regex patterns using AST" do
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

    # Approach 3: Use Igniter.Code.Common to build the AST properly
    try do
      _result = igniter
      |> Igniter.Project.Config.configure(
        "config/dev.exs",
        app_name, 
        [endpoint_module, :live_reload, :patterns],
        # Use quoted expressions instead of compiled regex
        [
          {:sigil_r, [], [{:<<>>, [], ["priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$"]}, []]},
          {:sigil_r, [], [{:<<>>, [], ["priv/gettext/.*(po)$"]}, []]},
          {:sigil_r, [], [{:<<>>, [], ["lib/test_web/(controllers|live|components)/.*(ex|heex)$"]}, []]}
        ]
      )
      |> puts_diff(label: "AST-based Regex Patterns")
      
      IO.puts("✅ AST-based regex patterns worked!")
    rescue
      e ->
        IO.puts("❌ AST-based regex patterns failed: #{Exception.message(e)}")
    end

    # Approach 4: Use Macro.escape on the regex
    try do
      patterns = [
        ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
        ~r"priv/gettext/.*(po)$",
        ~r"lib/test_web/(controllers|live|components)/.*(ex|heex)$"
      ]
      
      escaped_patterns = Enum.map(patterns, &Macro.escape/1)
      
      _result2 = igniter
      |> Igniter.Project.Config.configure(
        "config/dev.exs",
        app_name, 
        [endpoint_module, :live_reload, :patterns],
        escaped_patterns
      )
      |> puts_diff(label: "Macro.escape Patterns")
      
      IO.puts("✅ Macro.escape patterns worked!")
    rescue
      e ->
        IO.puts("❌ Macro.escape patterns failed: #{Exception.message(e)}")
    end
  end
end