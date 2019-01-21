defmodule TweeterWeb.Schema do
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
