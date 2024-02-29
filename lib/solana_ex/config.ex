defmodule SolanaEx.Config do
  @moduledoc """
  Configuration for Tesla client
  """
  def rpc_url do
    Application.get_env(:solana_ex, :url)
    |> case do
      url when is_binary(url) and url != "" ->
        url

      no_url ->
        raise ArgumentError,
          message:
            ~s|Please set config variable `config :solana_ex, :url "http://..."`, got: `#{inspect(no_url)}`|
    end
  end

  def adapter do
    Application.get_env(:solana_ex, :adapter) || Tesla.Adapter.Httpc
  end

  def middlewares do
    Application.get_env(:solana_ex, :middleware) || []
  end
end
