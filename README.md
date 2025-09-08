# PhoenixWebConsole

Phoenix web console logging library. Stream your Phoenix server logs directly to your browser's web console during development for faster debugging.

## Features

- 🔄 **Real-time server logs** in your browser console
- 🎯 **Co-located debugging** - see server and client logs together
- 🛠️ **Simple manual setup** - add a few lines of code
- 🔧 **Development only** - no impact on production

## Installation

### Step 1: Add the dependency

Add to your `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_web_console, "~> 0.1.0"},
    {:phoenix_live_reload, "~> 1.5"}  # Required for web console functionality
  ]
end
```

Then run:
```bash
mix deps.get
```

### Step 2: Configure your endpoint

Add to your `config/dev.exs`:

```elixir
config :my_app, MyAppWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/my_app_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]
```

### Step 3: Enable client-side logging

Add to your `assets/js/app.js`:

```javascript
// Enable Phoenix Web Console Logger
window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
  // Enable server log streaming to client
  reloader.enableServerLogs()
  window.liveReloader = reloader
})
```

That's it! 🎉

## Usage

1. Start your Phoenix server: `mix phx.server`
2. Open your browser's developer tools (F12)
3. Navigate to the Console tab
4. Server logs will appear alongside your JavaScript logs

### Controls

- **Disable server logs**: `window.liveReloader.disableServerLogs()`
- **Re-enable server logs**: `window.liveReloader.enableServerLogs()`

## Requirements

- Phoenix LiveView application
- `phoenix_live_reload ~> 1.5`
- Development environment only

## How It Works

This library implements the Phoenix web console logging feature described in the [Fly.io Phoenix Dev Blog](https://fly.io/phoenix-files/phoenix-dev-blog-server-logs-in-the-browser-console/). It:

1. Attaches an Erlang `:logger` handler to capture server logs
2. Uses Elixir's Registry for local pubsub to broadcast logs
3. Leverages Phoenix LiveReload's existing channel to stream logs to the browser
4. Displays formatted logs in the browser console with appropriate colors

## Development

To work on this library:

```bash
git clone https://github.com/AJReade/phoenix_web_console.git
cd phoenix_web_console
mix deps.get
mix test
```

## Automatic Installation (Advanced)

For an automated installation experience, check out the `igniter` branch which includes Igniter-based installation:

```bash
git checkout igniter
mix igniter.install AJReade.phoenix_web_console AJReade/phoenix_web_console@igniter
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

Based on the implementation described by Chris McCord in the [Phoenix Dev Blog](https://fly.io/phoenix-files/phoenix-dev-blog-server-logs-in-the-browser-console/).