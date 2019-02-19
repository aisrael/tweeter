defmodule TweeterWeb.Schema do
  @moduledoc """
  This module defines the Tweeter GraphQL Schema.
  """

  use Absinthe.Schema

  import_types(TweeterWeb.Schema.ContentTypes)

  query do
    import_fields(:tweet_queries)
  end

  mutation do
    import_fields(:tweet_commands)
  end
end
