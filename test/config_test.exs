defmodule SolanaEx.ConfigTest do
  use ExUnit.Case, async: false
  alias SolanaEx.Config
  alias SolanaEx.Test.Helpers

  describe "rpc_url" do
    test "errors with no config" do
      assert_raise ArgumentError, fn -> Config.rpc_url() end
    end

    test "correctly configures url" do
      url = "https://api.mainnet-beta.solana.com/"
      Helpers.set_application_env(:solana_ex, :url, url)
      assert Config.rpc_url() == url
    end
  end

  describe "adapter" do
    test "sensible default" do
      assert Config.adapter() == Tesla.Adapter.Httpc
    end

    test "configures with config" do
      Helpers.set_application_env(:solana_ex, :adapter, Tesla.Adapter.Hackney)
      assert Config.adapter() == Tesla.Adapter.Hackney
    end
  end

  describe "middlewares" do
    test "sensible default" do
      assert Config.middlewares() == []
    end

    test "configures with config" do
      Helpers.set_application_env(:solana_ex, :middleware, [Tesla.Middleware.Retry])
      assert Config.middlewares() == [Tesla.Middleware.Retry]
    end
  end
end
