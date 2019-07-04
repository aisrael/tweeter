defmodule TweeterWeb.Resolvers.Tweet do
  @moduledoc """
  This module defines the Tweet resolvers
  """

  @type resolver_output :: ok_output | error_output | plugin_output

  @type ok_output :: {:ok, any}
  @type error_output :: {:error, binary}
  @type plugin_output :: {:plugin, Absinthe.Resolution.Plugin.t(), term}

  @spec find_tweet(any, %{atom => any}, Absinthe.Resolution.t()) :: resolver_output
  def find_tweet(_parent, %{id: id}, _resolution) do
    {:ok, Tweeter.Tweets.get_tweet!(id)}
  end

  @spec list_tweets(any, %{atom => any}, Absinthe.Resolution.t()) :: resolver_output
  def list_tweets(_parent, _, _resolution) do
    tweets =
      Tweeter.Tweets.list_tweets()
      |> Enum.map(fn tweet ->
        %{
          id: tweet.id,
          handle: tweet.handle,
          content: tweet.content,
          timestamp: tweet.inserted_at |> DateTime.to_unix(:millisecond)
        }
      end)

    {:ok, tweets}
  end

  @spec create_tweet(any, %{atom => any}, Absinthe.Resolution.t()) :: resolver_output
  def create_tweet(_parent, %{handle: handle, content: content}, _resolution) do
    {:ok, uuid} = Tweeter.Tweets.create_tweet(%{handle: handle, content: content})
    {:ok, %{uuid: uuid}}
  end
end
