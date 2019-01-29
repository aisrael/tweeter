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

  @spec find_tweet(any, %{atom => any}, Absinthe.Resolution.t()) :: resolver_output
  def list_tweets(_parent, _, _resolution) do
    {:ok, Tweeter.Tweets.list_tweets()}
  end
end
