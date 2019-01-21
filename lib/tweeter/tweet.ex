defmodule Tweeter.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :handle, :string
    field :content, :string

    timestamps(updated_at: false, type: :utc_datetime)
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:handle, :content])
    |> validate_required([:handle, :content])
  end
end
