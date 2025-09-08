defmodule MinimalInstallTest do
  use ExUnit.Case
  import Igniter.Test

  test "minimal config configure" do
    igniter = test_project(
      files: %{
        "config/dev.exs" => """
        import Config

        config :test, TestWeb.Endpoint,
          http: [ip: {127, 0, 0, 1}, port: 4000]
        """
      }
    )

    # This should work without errors
    result = Igniter.Project.Config.configure(
      igniter,
      "config/dev.exs",
      :test,
      [:test_web_endpoint, :debug],
      true
    )

    IO.puts("Minimal test passed!")
  end
end