defmodule SolanaEx.HttpClient do
  @moduledoc """
  HTTP client which uses Tesla to fulfill requests
  """
  use SolanaEx.Client.BaseClient
  alias SolanaEx.Config

  def post_request(payload, opts) do
    headers = Keyword.get(opts, :http_headers, [])

    client(opts)
    |> Tesla.post("", payload, headers: headers)
    |> decode_response()
  end

  defp client(opts) do
    url = Keyword.get(opts, :url) || Config.rpc_url()

    middleware = [{Tesla.Middleware.BaseUrl, url}, Tesla.Middleware.JSON | Config.middlewares()]

    adapter = Config.adapter()
    Tesla.client(middleware, adapter)
  end

  defp decode_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299 do
    case body do
      %{"result" => result} -> {:ok, result}
      %{"error" => error} -> {:error, error}
    end
  end

  defp decode_response({:ok, %Tesla.Env{body: body}}) do
    {:error, Map.get(body, "error")}
  end

  defp decode_response({:error, _} = error), do: error
end
