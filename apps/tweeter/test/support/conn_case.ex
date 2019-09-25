defmodule TweeterWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias TweeterWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint TweeterWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Tweeter.Repo)
    # TODO The ff. doesn't quite work
    # Ecto.Adapters.SQL.Sandbox.allow(Tweeter.Repo, self(), Tweeter.TweetsEventHandler)

    # So we need to ignore the :async tag
    unless tags[:async] do
      Sandbox.mode(Tweeter.Repo, {:shared, self()})
    end

    # Need to restart the Tweeter.TweetsEventHandler GenServer
    # see https://elixirforum.com/t/phoenix-testing-with-ecto-2-sandbox-access-from-processes/9174/11
    :ok = Supervisor.terminate_child(Tweeter.Supervisor, Tweeter.TweetsEventHandler)

    {:ok, _} = Supervisor.restart_child(Tweeter.Supervisor, Tweeter.TweetsEventHandler)

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
