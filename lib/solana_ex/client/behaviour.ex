defmodule SolanaEx.Client.Behaviour do
  @moduledoc false
  @type error :: {:error, map() | binary() | atom()}

  # API Methods
  @callback get_account_info(binary(), map()) :: {:ok, map()} | error()
  @callback get_balance(binary(), map()) :: {:ok, map()} | error()
  @callback get_block(non_neg_integer(), map()) :: {:ok, map()} | error()
  @callback get_latest_blockhash(map()) :: {:ok, map()} | error()
  @callback get_multiple_accounts(list()) :: {:ok, map()} | error()
  @callback get_program_account(binary()) :: {:ok, map()} | error()
  @callback get_recent_blockhash(map()) :: {:ok, map()} | error()
  @callback get_slot(map()) :: {:ok, non_neg_integer()} | error()
end
