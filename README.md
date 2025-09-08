# PhoenixWebConsole

Easy Phoenix web console logging installer using Igniter. Stream your Phoenix server logs directly to your browser's web console during development for faster debugging.

## Features

- 🔄 **Real-time server logs** in your browser console
- 🎯 **Co-located debugging** - see server and client logs together
- ⚡ **One-command install** using Igniter
- 🛠️ **Zero configuration** - works out of the box
- 🔧 **Development only** - no impact on production

## Installation

**One command. Zero configuration. That's it.**

```bash
mix igniter.install repo.phoenix_web_console AJReade/phoenix_web_console
```

> **Note:** Once published to Hex, you can use `mix igniter.install phoenix_web_console` instead.

This automatically:
- ✅ Adds the dependency to your `mix.exs`
- ✅ Updates your `config/dev.exs` to enable web console logging
- ✅ Updates your `assets/js/app.js` to receive server logs
- ✅ Ensures `phoenix_live_reload ~> 1.5` is available

**No manual code changes required!**

<details>
<summary>💡 Advanced: Manual Installation (click to expand)</summary>

If you prefer manual setup or need more control:

1. Add to your `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_web_console, "~> 0.1.0"}
  ]
end
```

2. Run `mix deps.get`

3. Enable in `config/dev.exs`:

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

4. Add to your `assets/js/app.js`:

```javascript
window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
  reloader.enableServerLogs()
  window.liveReloader = reloader
})
```

</details>

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
git clone https://github.com/yourusername/phoenix_web_console.git
cd phoenix_web_console
mix deps.get
mix test
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

Based on the implementation described by Chris McCord in the [Phoenix Dev Blog](https://fly.io/phoenix-files/phoenix-dev-blog-server-logs-in-the-browser-console/).

