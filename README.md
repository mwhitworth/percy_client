# Percy client for Elixir

An Elixir client for the visual testing and regression service [Percy](https://percy.io), following the instructions
in the ["Build your own SDK" section](https://www.browserstack.com/docs/percy/integrate/build-your-sdk) of the documentation.

The full documentation for this library can found on [HexDocs](https://hexdocs.pm/).

## Prerequisites

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

### snapshot(session, name)/2

For a given Wallaby session `session`, takes a screenshot of name `name` by checking to see if the local `percy` instance is running,
injecting the DOM with the Percy snapshot script and uploading it to the local running `percy` instance.

Returns :ok if the screenshot was taken without issue.

### percy_enabled?

Returns `true` if the local Percy server is running, `false` otherwise.
