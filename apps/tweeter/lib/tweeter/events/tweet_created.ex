# A TweetCreated event/Struct
defmodule Tweeter.Events.TweetCreated do
  alias __MODULE__
  defstruct [:id, :handle, :content, :timestamp]

  # Returns a new TweetCreated event
  @spec new(map) :: %TweetCreated{}
  def new(%{id: id, handle: handle, content: content, timestamp: timestamp})
      when is_integer(id) and is_binary(handle) and is_binary(content) and is_integer(timestamp) do
    %TweetCreated{
      id: id,
      handle: handle,
      content: content,
      timestamp: timestamp
    }
  end
end
