defmodule PercyClient.Cache do
  @moduledoc """
  Simple cache for state relating to PercyClient
  """

  def get_or_fetch(key, fetch) do
    case get(key) do
      nil ->
        value = fetch.()
        put(key, value)
        value

      value ->
        value
    end
  end

  defp get(key) do
    :persistent_term.get({__MODULE__, key})
  rescue
    _ -> nil
  end

  defp put(key, value) do
    :persistent_term.put({__MODULE__, key}, value)
  end
end
