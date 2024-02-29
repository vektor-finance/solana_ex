defmodule SolanaEx.HttpClientTest do
  use ExUnit.Case, async: false
  alias SolanaEx.HttpClient
  alias SolanaEx.Test.Helpers

  setup do
    Helpers.set_application_env(:solana_ex, :url, "http://localhost:8899")
    Helpers.set_application_env(:solana_ex, :adapter, Tesla.Mock)

    :ok
  end

  test "get_slot" do
    result = 1234

    mock_response(200, %{"result" => result})
    |> Tesla.Mock.mock()

    {:ok, ^result} = HttpClient.get_slot()
  end

  describe "errors" do
    test "handles 429" do
      error = %{"code" => 429, "message" => "Too many requests"}

      mock_response(429, %{"error" => error})
      |> Tesla.Mock.mock()

      {:error, ^error} = HttpClient.get_slot()
    end

    test "handle 200 which errors" do
      error = %{"code" => -32_602, "message" => "Invalid param: WrongSize"}

      mock_response(200, %{"error" => error})
      |> Tesla.Mock.mock()

      {:error, ^error} = HttpClient.get_balance("short")
    end

    test "tesla error" do
      Tesla.Mock.mock(fn _req -> {:error, :unexpected_error} end)

      {:error, :unexpected_error} = HttpClient.get_slot()
    end
  end

  defp mock_response(status_code, response) do
    fn %Tesla.Env{method: :post, body: request} ->
      %{"id" => id} = Jason.decode!(request)

      {:ok,
       %Tesla.Env{
         status: status_code,
         body: Map.merge(%{"jsonrpc" => "2.0", "id" => id}, response)
       }}
    end
  end
end
