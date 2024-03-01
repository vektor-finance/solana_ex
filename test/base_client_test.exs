defmodule SolanaEx.BaseClientTest do
  use ExUnit.Case

  defmodule ClientMock do
    use SolanaEx.Client.BaseClient

    def post_request(payload, opts) do
      payload
      |> case do
        %{"method" => method, "jsonrpc" => "2.0", "params" => params} -> {method, params, opts}
      end
    end
  end

  defmodule Helpers do
    def check(method, params \\ [], defaults \\ []) do
      method
      |> make_tuple
      |> assert_method(params, params ++ defaults)
    end

    def make_tuple(ex_method) do
      sol_method = camelize(ex_method)

      {ex_method, sol_method}
    end

    defp camelize(method) do
      method
      |> String.split("_")
      |> then(fn [h | t] ->
        h <> Enum.map_join(t, &String.capitalize/1)
      end)
    end

    def assert_method({ex_method, sol_method}, params, payload) do
      {result_sol_method, result_payload, _opts} =
        apply(ClientMock, String.to_atom(ex_method), params)

      assert result_sol_method == sol_method
      assert result_payload == payload
    end
  end

  @pubkey "7cVfgArCheMR6Cs4t6vz5rfnqd56vZq4ndaBrY5xkxXy"
  @slot 400

  test "get_account_info/1", do: Helpers.check("get_account_info", [@pubkey])
  test "get_balance/1", do: Helpers.check("get_balance", [@pubkey])
  test "get_block/1", do: Helpers.check("get_block", [@slot])
  test "get_latest_blockhash/0", do: Helpers.check("get_latest_blockhash")
  test "get_multiple_accounts/1", do: Helpers.check("get_multiple_accounts", [[@pubkey]])
  test "get_program_accounts/1", do: Helpers.check("get_program_accounts", [@pubkey])
  test "get_recent_blockhash/0", do: Helpers.check("get_recent_blockhash")
  test "get_slot/0", do: Helpers.check("get_slot")
end
