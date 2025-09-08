# Phoenix Web Console Example Usage

This example shows how to manually set up the PhoenixWebConsole package in a Phoenix application.

## Manual Installation

Follow these simple steps to add Phoenix Web Console to your application:

### Step 1: Add Dependencies
Add to your `mix.exs`:
```elixir
def deps do
  [
    {:phoenix_web_console, "~> 0.1.0"},
    {:phoenix_live_reload, "~> 1.5"}  # Required for web console functionality
  ]
end
```

Run: `mix deps.get`

### Step 2: Configure Your Endpoint

Add to your `config/dev.exs`:
```elixir
config :my_app, MyAppWeb.Endpoint,
  live_reload: [
    web_console_logger: true,  # ← Enable web console logging
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$", 
      ~r"lib/my_app_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]
```

### Step 3: Enable Client-Side Logging

Add to your `assets/js/app.js`:
```javascript
// Phoenix Web Console Logger - Stream server logs to browser console
window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
  // Enable server log streaming to client.
  // Disable with reloader.disableServerLogs()
  reloader.enableServerLogs()
  window.liveReloader = reloader
})
```

That's it! 🎉

## Development Usage

1. Start your Phoenix server:
   ```bash
   mix phx.server
   ```

2. Open your browser and navigate to your app

3. Open browser developer tools (F12) and go to the Console tab

4. Server logs will now appear in the console alongside JavaScript logs!

## Runtime Controls

In your browser console, you can control the logging:

```javascript
// Disable server logs
window.liveReloader.disableServerLogs()

// Re-enable server logs  
window.liveReloader.enableServerLogs()
```

## Example Output

When you have both server and client logs appearing in the browser console:

```
[09:14:23.456] [info] GET /
[09:14:23.458] [info] Sent 200 in 2ms  
[09:14:23.461] JavaScript: Page loaded successfully
[09:14:25.123] [debug] Processing user action...
[09:14:25.125] JavaScript: Button clicked
[09:14:25.128] [info] Updated user preferences
```

## Benefits

- **Faster debugging**: No more switching between browser and terminal
- **Context preservation**: See server and client logs chronologically  
- **Real-time updates**: Logs appear immediately as they happen
- **Development only**: No impact on production builds
- **Simple setup**: Just add a few lines of code

This makes Phoenix development much more productive by keeping all your debugging information in one place!

## Automatic Installation (Advanced)

For an automated installation experience, check out the `igniter` branch which includes Igniter-based installation that handles all the setup automatically.