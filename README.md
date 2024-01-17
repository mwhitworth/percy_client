# Percy client for Elixir

An Elixir client for the visual testing and regression service [Percy](https://percy.io), following the instructions
in the ["Build your own SDK" section](https://www.browserstack.com/docs/percy/integrate/build-your-sdk) of the documentation.

The full documentation for this library can found on [HexDocs](https://hexdocs.pm/).

```elixir
defmodule MyApp.PercyTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "home page functionality" do
    session
    |> visit("/home")
    |> PercyClient.snapshot("initial home page", widths: [360, 1280])
  end
end
```

## Prerequisites

### Wallaby

Percy requires a live browser session to inject Javascript and take a snapshot of the DOM. [Wallaby](https://github.com/elixir-wallaby/wallaby)
is a library that creates a browser session (using ChromeDriver or Selenium) to interact with.

Ensure that the steps described in the project README's ["Setup" section](https://github.com/elixir-wallaby/wallaby?tab=readme-ov-file#setup)
are completed.

### Percy

```
npm install -g @percy/cli
```

for the `percy` command line tool that provides the infrastructure for screenshots. (https://github.com/percy/cli)

## Installation

The package can be installed by adding `percy_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:percy_client, "~> 0.1.0", only: :test}
  ]
end
```

## Test functions

### snapshot(session, name, opts \\ [])

For a given Wallaby session `session`, takes a screenshot of name `name` by checking to see if the local `percy` instance is running,
injecting the DOM with the Percy snapshot script and uploading it to the local running `percy` instance. You can pass the
[Percy options](https://www.browserstack.com/docs/percy/take-percy-snapshots/overview#all-configuration-options) as `opts`, though
the snapshot options with a dash listed should be passed as atoms with an underscore separator, to follow Elixir conventions
(e.g. `min-height: 600` in JSON should be `min_height: 600` in the keyword list)

Returns :ok if the screenshot was taken without issue.

### percy_enabled?

Returns `true` if the local Percy server is running, `false` otherwise.
