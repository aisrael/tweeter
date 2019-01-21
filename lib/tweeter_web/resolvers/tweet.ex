defmodule TweeterWeb.Resolvers.Tweet do
  def find_tweet(_parent, %{id: id}, _resolution) do
    {:ok, Tweeter.Tweets.get_tweet!(id)}
  end
end
