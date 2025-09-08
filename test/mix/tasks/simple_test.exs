defmodule SimpleInstallTest do
  use ExUnit.Case
  import Igniter.Test

  alias Mix.Tasks.PhoenixWebConsole.Install

  test "basic igniter setup" do
    igniter = test_project()
    app_name = Igniter.Project.Application.app_name(igniter)
    IO.puts("App name: #{inspect(app_name)}")
    
    # Test just the dependency addition
    result = igniter
    |> Install.ensure_phoenix_live_reload_dependency()
    |> puts_diff(label: "Dependency Only")
    
    IO.puts("Success!")
  end

  test "basic config test" do
    igniter = test_project(
      files: %{
        "config/dev.exs" => """
        import Config

        config :test, TestWeb.Endpoint,
          http: [ip: {127, 0, 0, 1}, port: 4000]
        """
      }
    )
    
    app_name = Igniter.Project.Application.app_name(igniter)
    IO.puts("App name: #{inspect(app_name)}")
    
    # Let's see what files exist
    IO.puts("Files in igniter: #{inspect(igniter.rewrite.sources |> Enum.map(& &1.path))}")
    
    # Test just one config operation with the right endpoint module
    _result = igniter
    |> Igniter.Project.Config.configure(
      "config/dev.exs",
      app_name,
      [:test_web_endpoint, :live_reload, :web_console_logger],
      true
    )
    |> puts_diff(label: "Config with TestWebEndpoint")
    
    IO.puts("Config test success!")
  end
end