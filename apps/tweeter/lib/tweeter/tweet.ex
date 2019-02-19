defmodule Tweeter.Tweet do
  @moduledoc """
  This module defines a Tweeter which is just a handle and some content.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "tweets" do
    field :handle, :string
    field :content, :string

    timestamps(updated_at: false, type: :utc_datetime)
  end

  @doc false
  @spec changeset(%Tweet{}, map) :: %Ecto.Changeset{}
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:handle, :content])
    |> validate_required([:handle, :content])
  end
end
