defmodule TweeterWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  @desc "A Tweet"
  object :tweet do
    field :id, :id
    field :handle, :string
    field :content, :string
  end
end
