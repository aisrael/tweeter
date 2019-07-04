defmodule Tweeter.Commands.CreateTweet do
  @moduledoc """
  A CreateTweet command
  """

  defstruct [:uuid, data: %{}]

  alias __MODULE__
  alias Tweeter.Events.TweetCreated
  alias Tweeter.Repo
  alias Tweeter.Tweet

  # Returns a new CreateTweet command
  @spec new(map) :: {:ok, %CreateTweet{}} | {:error, list}
  def new(%{handle: handle, content: content})
      when is_binary(handle) and is_binary(content) do
    attrs = %{handle: handle, content: content}
    changeset = Tweet.changeset(%Tweet{}, attrs)

    if changeset.valid? do
      id = Repo.nextval!("tweets_id_seq")

      command = %CreateTweet{
        uuid: UUID.uuid1(:hex),
        data: %{
          id: id,
          handle: handle,
          content: content,
          timestamp: utc_now_millis()
        }
      }

      {:ok, command}
    else
      {:error, changeset.errors}
    end
  end

  @doc """
  Transform this CreateTweet command into a TweetCreated event
  """
  @spec apply(%CreateTweet{}) :: %TweetCreated{}
  def apply(%CreateTweet{} = self) do
    TweetCreated.new(self.data)
  end

  # Returns the current time as milliseconds from epoch
  @spec utc_now_millis :: integer
  defp utc_now_millis do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end
end
