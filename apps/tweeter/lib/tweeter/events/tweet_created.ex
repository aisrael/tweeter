# A TweetCreated event
defmodule Tweeter.TweetCreated do
  defstruct [:id, :handle, :content, :timestamp]

  @spec new(map) :: %Tweeter.TweetCreated{}
  def new(%{id: id, handle: handle, content: content})
      when is_integer(id) and is_binary(handle) and is_binary(content) do
    %Tweeter.TweetCreated{
      id: id,
      handle: handle,
      content: content,
      timestamp: utc_now_millis()
    }
  end

  defp utc_now_millis() do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end
end
