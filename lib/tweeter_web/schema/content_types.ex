defmodule TweeterWeb.Schema.ContentTypes do
  @moduledoc """
  This module defines the Tweeter GraphQL content types.
  """

  use Absinthe.Schema.Notation

  @desc "A Tweet"
  object :tweet do
    field :id, :id
    field :handle, :string
    field :content, :string
  end
end
