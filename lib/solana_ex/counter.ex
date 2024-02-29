defmodule SolanaEx.Counter do
  @moduledoc """
  Counter for incrementing JSON-RPC id
  """
  use GenServer
  @tab :solana_ex_rpc_requests_counter

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(state) do
    @tab = :ets.new(@tab, [:set, :named_table, :public, write_concurrency: true])
    {:ok, state}
  end

  def increment(key) do
    :ets.update_counter(@tab, key, {2, 1}, {key, 0})
  end
end
