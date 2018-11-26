defmodule Tweeter.Tweet do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tweets" do
    field :content, :string
    field :handle, :string

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:handle, :content])
    |> validate_required([:handle, :content])
  end
end
