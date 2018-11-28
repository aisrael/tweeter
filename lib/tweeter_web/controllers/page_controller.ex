defmodule TweeterWeb.PageController do
  use TweeterWeb, :controller

  alias Tweeter.Tweets
  alias Tweeter.Tweet

  def index(conn, _params) do
    tweets = Tweets.list_tweets()
    changeset = Tweets.change_tweet(%Tweet{})
    render(conn, "tweets.html",
      tweets: tweets,
      changeset: changeset)
  end

  def create(conn, %{"tweet" => tweet_params}) do
    case Tweets.create_tweet(tweet_params) do
      {:ok, tweet} ->
        conn
        |> put_flash(:info, "Tweet created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        tweets = Tweets.list_tweets()
        render(conn, "tweets.html",
          tweets: tweets,
          changeset: changeset)
    end
  end

  def format_timestamp(tweet) do
    tweet.inserted_at |>
    Timex.Timezone.convert(Timex.Timezone.local) |>
    Timex.format!("{M}/{D}/{YYYY} {h24}:{m}{am}")
  end
end
