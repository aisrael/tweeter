defmodule Tweeter.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false
  alias Tweeter.Repo

  alias Tweeter.Tweet

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
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_tweet(map) :: {:ok, %Tweet{}} | {:error, map}
  def create_tweet(attrs \\ %{}) do
    %Tweet{}
    |> Tweet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_tweet(map, map) :: {:ok, %Tweet{}} | {:error, map}
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_tweet(%Tweet{}) :: {:ok, %Tweet{}} | {:error, map}
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
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
