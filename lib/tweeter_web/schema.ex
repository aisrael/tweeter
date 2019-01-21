defmodule TweeterWeb.Schema do
  @moduledoc """
  This module defines the Tweeter GraphQL Schema.
  """

  use Absinthe.Schema

  import_types(TweeterWeb.Schema.ContentTypes)

  alias TweeterWeb.Resolvers

  query do
    @desc "Get tweet"
    field :tweet, :tweet do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Tweet.find_tweet/3)
    end
  end
end
