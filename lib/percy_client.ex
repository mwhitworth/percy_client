defmodule PercyClient do
  @moduledoc """
  Wrapper functions for the Percy client API, for visual regression testing.
  """

  import Wallaby.Browser, only: [current_url: 1, execute_script: 2, execute_script: 4]

  alias PercyClient.{Cache, HTTPClient}
  alias Wallaby.Session

  @spec snapshot(Session.t(), String.t()) :: :ok | :error
  @spec snapshot(Session.t(), String.t(), Keyword.t()) :: :ok | :error
  @doc """
  Takes a snapshot of the current page and posts it to Percy.
  """
  def snapshot(%Session{} = session, name, opts \\ []) do
    with true <- percy_enabled?(),
         :ok <- inject_script(session),
         {:ok, dom_snapshot} <- snapshot_dom(session, opts) do
      post_dom(name, session, dom_snapshot)
    else
      _ -> :error
    end
  end

  @spec percy_enabled?() :: boolean
  @doc """
  Returns true if the local Percy server is running, false otherwise.
  """
  def percy_enabled? do
    Cache.get_or_fetch(:percy_enabled?, fn ->
      case HTTPClient.get("/healthcheck") do
        {:ok, _} -> true
        _ -> false
      end
    end)
  end

  #

  defp inject_script(%Session{} = session) do
    dom_script = Cache.get_or_fetch(:dom_script, fn ->
      {:ok, %{body: body}} = HTTPClient.get("/dom.js")
      body
    end)

    execute_script(session, dom_script)
    :ok
  end

  defp snapshot_dom(%Session{} = session, opts) do
    execute_script(
      session,
      serialize_script(opts),
      [],
      &send(self(), {:result, &1})
    )

    receive do
      {:result, result} -> {:ok, result}
    end
  end

  defp post_dom(name, session, dom_snapshot) do
    {:ok, _} =
      HTTPClient.post("/snapshot", %{
        name: name,
        url: current_url(session),
        domSnapshot: dom_snapshot
      })
  end

  defp serialize_script(opts) do
    arg_map = Map.new(opts, fn {k, v} -> {convert_key(k), v} end)

    "return PercyDOM.serialize(#{Jason.encode!(arg_map)})"
  end

  defp convert_key(key) do
    key
    |> to_string()
    |> String.replace("_", "-")
  end
end
