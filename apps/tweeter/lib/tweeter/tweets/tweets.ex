defmodule Tweeter.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false

  alias Tweeter.Repo
  alias Tweeter.Tweet
  alias Tweeter.Commands.CreateTweet

  require Logger

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  @spec list_tweets :: [%Tweet{}]
  def list_tweets do
    Repo.all(from Tweet, order_by: [desc: :inserted_at])
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
  def create_tweet(%{} = attrs) do
    case CreateTweet.new(attrs) do
      {:ok, command} ->
        Tweeter.Commander.publish(command)
        # Also a hack. Not sure what to return now that everything is async
        {:ok, command.uuid}

      {:error, errors} ->
        {:error, errors}
    end
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
