defmodule DebugRewriteSourceTest do
  use ExUnit.Case
  import Igniter.Test

  test "examine rewrite source structure" do
    igniter = test_project(
      files: %{
        "assets/js/app.js" => """
        // Test content
        console.log("hello");
        """
      }
    )

    igniter
    |> Igniter.update_file("assets/js/app.js", fn content ->
      IO.puts("Content type: #{inspect(content.__struct__)}")
      IO.puts("Content fields: #{inspect(Map.keys(content))}")
      IO.puts("Content: #{inspect(content)}")
      
      # Just return the content unchanged for now
      content
    end)
    |> puts_diff(label: "Debug Rewrite Source")

    IO.puts("Debug test completed!")
  end
end