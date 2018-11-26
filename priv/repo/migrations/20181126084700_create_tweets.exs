defmodule Tweeter.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :handle, :string
      add :content, :string

      timestamps()
    end

  end
end
