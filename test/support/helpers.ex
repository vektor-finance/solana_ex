defmodule SolanaEx.Test.Helpers do
  @moduledoc """
  Helpers used in testing
  """

  @doc """
  Sets an application variable during a test and then resets it after the test finishes

  Given that application variables are global, this cannot be used in async tests.
  """
  def set_application_env(app, key, value) do
    previous_value = Application.get_env(app, key)
    Application.put_env(app, key, value)
    ExUnit.Callbacks.on_exit(fn -> Application.put_env(app, key, previous_value) end)
  end
end
