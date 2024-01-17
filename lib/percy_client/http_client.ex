defmodule PercyClient.HTTPClient do
  @moduledoc """
  Tesla client for the local Percy HTTP server.
  """

  use Tesla

  plug(TeslaExtra.RuntimeOpts,
    plug: Tesla.Middleware.BaseUrl,
    opts: fn -> System.get_env("PERCY_CLI_API", "http://localhost:5338/percy") end
  )

  plug(Tesla.Middleware.JSON)
end
