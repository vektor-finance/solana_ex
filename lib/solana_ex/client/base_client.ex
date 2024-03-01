defmodule SolanaEx.Client.BaseClient do
  @moduledoc """
  Base client which can be overriden

  Override by using this module, and then implementing `post_request/2`
  """
  defmacro __using__(_) do
    quote do
      @behaviour unquote(SolanaEx.Client.Behaviour)
      alias unquote(SolanaEx.Counter)

      @impl true
      def get_account_info(account, config \\ %{}, opts \\ []) do
        params = build_params([account, config])
        request("getAccountInfo", params, opts)
      end

      @impl true
      def get_balance(account, config \\ %{}, opts \\ []) do
        params = build_params([account, config])
        request("getBalance", params, opts)
      end

      @impl true
      def get_block(slot, config \\ %{}, opts \\ []) do
        params = build_params([slot, config])
        request("getBlock", params, opts)
      end

      @doc """
      This method is only available in `solana-core` v1.9 or newer.
      Please use `getRecentBlockhash` for `solana-core` v1.8 and below.
      """
      @impl true
      def get_latest_blockhash(config \\ %{}, opts \\ []) do
        params = build_params([config])
        request("getLatestBlockhash", params, opts)
      end

      @impl true
      def get_multiple_accounts(programs, config \\ %{}, opts \\ []) do
        params = build_params([programs, config])
        request("getMultipleAccounts", params, opts)
      end

      @impl true
      def get_program_account(program, config \\ %{}, opts \\ []) do
        params = build_params([program, config])
        request("getProgramAccount", params, opts)
      end

      @impl true
      def get_recent_blockhash(config \\ %{}, opts \\ []) do
        params = build_params([config])
        request("getRecentBlockhash", params, opts)
      end

      @impl true
      def get_slot(config \\ %{}, opts \\ []) do
        params = build_params([config])
        request("getSlot", params, opts)
      end

      def request(method_name, params, opts) do
        method_name
        |> add_request_info(params)
        |> server_request(opts)
      end

      defp build_params([]), do: []
      defp build_params([map | t]) when map == %{}, do: t
      defp build_params([h | t]), do: [h | build_params(t)]

      defp add_request_info(method_name, params \\ []) do
        %{}
        |> Map.put("method", method_name)
        |> Map.put("jsonrpc", "2.0")
        |> Map.put("params", params)
        |> add_id()
      end

      defp add_id(map) do
        Map.put(map, "id", Counter.increment(:rpc_counter))
      end

      defp server_request(payload, opts) do
        post_request(payload, opts)
      end

      defp post_request(payload, opts) do
        {:error, :not_implemented}
      end

      defoverridable post_request: 2
    end
  end
end
