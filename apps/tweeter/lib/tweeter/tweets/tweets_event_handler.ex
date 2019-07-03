defmodule Tweeter.TweetsEventHandler do
  @moduledoc """
  Handles Tweet events
  """

  use GenServer
  require Logger

  alias Tweeter.Repo
  alias Tweeter.Tweet

  @stream "tweeter"

  @spec start_link(term()) :: GenServer.on_start()
  def start_link(args \\ :none) do
    Logger.debug("start_link(#{inspect(args)})")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec tweet_created(map) :: :ok
  def tweet_created(attrs) do
    Logger.debug(fn -> "tweet_created(#{inspect(attrs)})" end)
    GenServer.cast(__MODULE__, {:tweet_created, attrs})
  end

  @impl true
  def init(:ok) do
    Logger.debug(fn -> "init(:ok)" end)
    res = Extreme.subscribe_to(Tweeter.EventStore, self(), @stream)
    Logger.debug(fn -> "res => #{inspect(res)}" end)
    {:ok, :ok}
  end

  # Handle events from EventStore
  @impl true
  def handle_info({:on_event, event}, state) do
    Logger.debug(fn -> "New event on stream '#{@stream}': #{inspect(event)}" end)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:tweet_created, attrs}, state) do
    Logger.debug(fn -> "handle_cast({:tweet_created, #{inspect(attrs)}}, #{state})" end)

    %Tweet{}
    |> Tweet.insert(attrs)
    |> Repo.insert()

    {:noreply, state}
  end
end
