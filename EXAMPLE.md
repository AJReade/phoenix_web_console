# Phoenix Web Console Example Usage

This example shows how to use the PhoenixWebConsole package in a Phoenix application.

## Installation via Igniter (Recommended)

In your Phoenix application directory, run:

```bash
mix igniter.install phoenix_web_console
```

This will automatically:
- Add the dependency to your `mix.exs`
- Update `config/dev.exs` to enable web console logging  
- Update `assets/js/app.js` to receive server logs
- Ensure `phoenix_live_reload ~> 1.5` is available

## What Gets Configured

### config/dev.exs
```elixir
config :my_app, MyAppWeb.Endpoint,
  live_reload: [
    web_console_logger: true,  # ← This gets added
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$", 
      ~r"lib/my_app_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]
```

### assets/js/app.js
```javascript
// This gets appended to your app.js:

// Phoenix Web Console Logger - Stream server logs to browser console
window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
  // Enable server log streaming to client.
  // Disable with reloader.disableServerLogs()
  reloader.enableServerLogs()
  window.liveReloader = reloader
})
```

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
- **Zero configuration**: Works out of the box after installation

This makes Phoenix development much more productive by keeping all your debugging information in one place!