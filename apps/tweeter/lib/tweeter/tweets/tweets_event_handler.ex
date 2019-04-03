defmodule Tweeter.TweetsEventHandler do
  @moduledoc """
  Handles Tweet events
  """

  use GenServer
  require Logger

  alias Tweeter.Repo
  alias Tweeter.Tweet

  @spec start_link(term()) :: GenServer.on_start()
  def start_link(args \\ :none) do
    Logger.debug("start_link(#{inspect(args)})")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec tweet_created(map) :: :ok
  def tweet_created(attrs) do
    Logger.debug("tweet_created(#{inspect(attrs)})")
    GenServer.cast(__MODULE__, {:tweet_created, attrs})
  end

  @impl true
  def init(:ok) do
    Logger.debug("init(:ok)")
    {:ok, :ok}
  end

  @impl true
  def handle_cast({:tweet_created, attrs}, state) do
    Logger.debug("handle_cast({:tweet_created, #{inspect(attrs)}}, #{state})")

    %Tweet{}
    |> Tweet.insert(attrs)
    |> Repo.insert()

    {:noreply, state}
  end
end
