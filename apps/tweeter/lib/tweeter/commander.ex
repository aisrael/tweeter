defmodule Tweeter.Commander do
  @moduledoc """
  A command dispatcher and handler using [RabbitMQ PubSub](https://www.rabbitmq.com/tutorials/tutorial-three-elixir.html)
  """
  use GenServer
  use AMQP

  alias Extreme.Msg, as: ExMsg

  require Logger

  @exchange_name "tweeter"

  @doc """
  Starts this GenServer process
  """
  @spec start_link(term()) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, :nothing, name: __MODULE__)
  end

  @impl true
  @spec init(Connection.t()) :: {:ok, Channel.t()}
  def init(:nothing) do
    with {:ok, connection} <- Connection.open(),
         {:ok, channel} <- Channel.open(connection),
         :ok <- Exchange.declare(channel, @exchange_name, :fanout),
         {:ok, %{queue: queue_name}} <- Queue.declare(channel, "", exclusive: true),
         :ok <- Queue.bind(channel, queue_name, @exchange_name),
         :ok = Basic.qos(channel, prefetch_count: 10),
         {:ok, _consumer_tag} = Basic.consume(channel, queue_name) do
      {:ok, channel}
    end
  end

  @doc """
  Publishe the given command to RabbitMQ (handled asynchronously by `handle_cast/2` below)
  """
  @spec publish(any()) :: :ok
  def publish(command) do
    Logger.debug(fn -> "publish(#{inspect(command)})" end)
    GenServer.cast(__MODULE__, {:publish, command})
  end

  @doc """
  Asynchronously encodes the command (using `:erlang.term_to_binary/1`) and publishes
  it to the RabbitMQ exchange
  """
  @impl true
  def handle_cast({:publish, command}, channel) do
    Logger.debug(fn -> "handle_cast({:publish, #{inspect(command)}}, channel)" end)

    payload = :erlang.term_to_binary(command)
    ret = Basic.publish(channel, @exchange_name, "", payload)

    if :ok == ret do
      Logger.info(fn -> "Published: #{inspect(payload)}" end)
    else
      Logger.warn(fn -> "Basic.publish/4 returned #{inspect(ret)}" end)
    end

    {:noreply, channel}
  end

  # The actual handler that processes the command
  defp consume(channel, tag, redelivered, payload) do
    command = :erlang.binary_to_term(payload)
    Logger.debug(fn -> "command => #{inspect(command)}" end)

    # This is a hack. We should probably use Protocols here now
    event = command.__struct__.apply(command)
    Logger.debug(fn -> "event => #{inspect(event)}" end)

    emit_event(event)
  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise consumer will stop
    # receiving messages.
    exception ->
      Logger.warn(fn -> inspect(exception) end)
      Logger.warn(fn -> "Error consuming command #{inspect(payload)}" end)
      :ok = Basic.reject(channel, tag, requeue: not redelivered)
  end

  defp emit_event(event) do
    Logger.debug(fn -> "emit_event(#{inspect(event)}" end)

    write_events =
      event
      |> to_proto_event
      |> List.wrap()
      |> to_write_events

    Extreme.execute(Tweeter.EventStore, write_events)
  end

  defp to_proto_event(event) do
    # "Tweeter.Events.*" -> "Tweeter.*"
    event_type = event.__struct__ |> Module.split() |> List.delete_at(1) |> Enum.join(".")
    Logger.debug(fn -> "event_type => #{event_type}" end)

    ExMsg.NewEvent.new(
      # Ecto.UUID.generate()?
      event_id: Extreme.Tools.gen_uuid(),
      event_type: event_type,
      data_content_type: 0,
      metadata_content_type: 0,
      data: :erlang.term_to_binary(Map.from_struct(event)),
      metadata: ""
    )
  end

  defp to_write_events(proto_events) do
    ExMsg.WriteEvents.new(
      event_stream_id: "tweeter",
      expected_version: -2,
      events: proto_events,
      require_master: false
    )
  end

  @impl true
  def handle_info(
        {:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}},
        channel
      ) do
    Logger.debug(fn ->
      "handle_info({:basic_deliver, #{inspect(payload)}, %{delivery_tag: #{tag}, redelivered: #{
        redelivered
      }}})"
    end)

    # You might want to run payload consumption in separate Tasks in production
    consume(channel, tag, redelivered, payload)
    {:noreply, channel}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  @impl true
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, channel) do
    {:noreply, channel}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  @impl true
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, channel) do
    {:stop, :normal, channel}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  @impl true
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, channel) do
    {:noreply, channel}
  end
end
