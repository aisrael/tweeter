defmodule Tweeter.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias Tweeter.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Tweeter.DataCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Tweeter.Repo)

    unless tags[:async] do
      Sandbox.mode(Tweeter.Repo, {:shared, self()})
    end

    # Need to restart the Tweeter.TweetsEventHandler GenServer
    # see https://elixirforum.com/t/phoenix-testing-with-ecto-2-sandbox-access-from-processes/9174/11
    :ok = Supervisor.terminate_child(Tweeter.Supervisor, Tweeter.TweetsEventHandler)

    {:ok, _} = Supervisor.restart_child(Tweeter.Supervisor, Tweeter.TweetsEventHandler)

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  @spec errors_on(%Ecto.Changeset{}) :: map
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
