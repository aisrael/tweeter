defmodule TweeterWeb.Schema.ContentTypes do
  @moduledoc """
  This module defines the Tweeter GraphQL content types.
  """

  use Absinthe.Schema.Notation

  alias TweeterWeb.Resolvers

  @desc "A Tweet"
  object :tweet do
    field :id, :id
    field :handle, :string
    field :content, :string
  end

  object :tweet_queries do
    @desc "Get tweet"
    field :tweet, :tweet do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Tweet.find_tweet/3)
    end

    @desc "List tweets"
    field :tweets, list_of(:tweet) do
      resolve(&Resolvers.Tweet.list_tweets/3)
    end
  end

  object :tweet_commands do
    @desc "Create tweet"
    field :create_tweet, type: :tweet do
      arg(:handle, non_null(:string))
      arg(:content, non_null(:string))

      resolve(&Resolvers.Tweet.create_tweet/3)
    end
  end
end
