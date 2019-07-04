defmodule Tweeter.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false

  alias Extreme.Msg, as: ExMsg
  alias Tweeter.Repo
  alias Tweeter.Tweet

  require Logger

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  @spec list_tweets :: [%Tweet{}]
  def list_tweets do
    Repo.all(Tweet)
  end

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_tweet!(integer) :: %Tweet{}
  def get_tweet!(id), do: Repo.get!(Tweet, id)

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, 12}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_tweet(map) :: {:ok, integer} | {:error, map}
  def create_tweet(attrs \\ %{}) do
    changeset = Tweet.changeset(%Tweet{}, attrs)

    if changeset.valid? do
      tweet_id = Repo.nextval!("tweets_id_seq")
      tweet_created(tweet_id, attrs)
      {:ok, tweet_id}
    else
      {:error, changeset}
    end
  end

  @spec tweet_created(integer, map) :: {:ok, integer}
  def tweet_created(tweet_id, attrs) do
    attrs
    |> Map.put(:id, tweet_id)
    |> Tweeter.TweetCreated.new()
    |> emit_event
  end

  defp emit_event(%Tweeter.TweetCreated{} = event) do
    Logger.debug(fn -> "emit_event(#{inspect(event)}" end)

    event_type = event.__struct__ |> Module.split() |> Enum.join(".")

    proto_events = [
      ExMsg.NewEvent.new(
        # Ecto.UUID.generate()?
        event_id: Extreme.Tools.gen_uuid(),
        event_type: event_type,
        data_content_type: 0,
        metadata_content_type: 0,
        data: :erlang.term_to_binary(Map.from_struct(event)),
        metadata: ""
      )
    ]

    write_events =
      ExMsg.WriteEvents.new(
        event_stream_id: "tweeter",
        expected_version: -2,
        events: proto_events,
        require_master: false
      )

    Extreme.execute(Tweeter.EventStore, write_events)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{source: %Tweet{}}

  """
  @spec change_tweet(%Tweet{}) :: %Ecto.Changeset{}
  def change_tweet(%Tweet{} = tweet) do
    Tweet.changeset(tweet, %{})
  end
end
