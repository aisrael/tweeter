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

  @impl true
  def init(:ok) do
    Logger.debug(fn -> "init(:ok)" end)
    res = Extreme.subscribe_to(Tweeter.EventStore, self(), @stream)
    Logger.debug(fn -> "res => #{inspect(res)}" end)
    {:ok, :ok}
  end

  # Handle events from EventStore
  @impl true
  def handle_info({:on_event, push}, state) do
    Logger.debug(fn -> "New event on stream '#{@stream}': #{inspect(push)}" end)

    push.event.data
    |> :erlang.binary_to_term()
    |> process_event(push.event.event_type)

    {:noreply, state}
  end

  defp process_event(
         %{id: id, handle: handle, content: content, timestamp: timestamp} = data,
         "Tweeter.TweetCreated"
       ) do
    Logger.debug(fn -> "process_event(#{inspect(data)})" end)

    {:ok, created_at} = DateTime.from_unix(timestamp, :millisecond)

    Logger.debug(fn -> "created_at => #{inspect(created_at)}" end)
    attrs = %{id: id, handle: handle, content: content, created_at: created_at}

    %Tweet{}
    |> Tweet.insert(attrs)
    |> Repo.insert()
  end
end
