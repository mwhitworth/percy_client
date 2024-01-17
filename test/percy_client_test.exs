defmodule PercyClientTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "takes a snapshot and uploads it to Percy", %{session: session} do
    session
    |> visit("http://www.example.com")
    |> PercyClient.snapshot("test snapshot", min_height: 1024)
  end
end
