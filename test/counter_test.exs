defmodule SolanaEx.CounterTest do
  use ExUnit.Case
  alias SolanaEx.Counter

  test "increments counter" do
    1 = Counter.increment(:rpc_counter_mock)
    2 = Counter.increment(:rpc_counter_mock)
  end
end
