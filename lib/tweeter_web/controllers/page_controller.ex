defmodule TweeterWeb.PageController do
  use TweeterWeb, :controller

  alias Tweeter.Tweet
  alias Tweeter.Tweets

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    tweets = Tweets.list_tweets()
    changeset = Tweets.change_tweet(%Tweet{})

    render(conn, "index.html",
      tweets: tweets,
      changeset: changeset
    )
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"tweet" => tweet_params}) do
    case Tweets.create_tweet(tweet_params) do
      {:ok, _tweet} ->
        conn
        |> put_flash(:info, "Tweet created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        tweets = Tweets.list_tweets()

        render(conn, "index.html",
          tweets: tweets,
          changeset: changeset
        )
    end
  end

  @spec format_timestamp(%Tweet{}) :: String.t()
  def format_timestamp(tweet) do
    tweet.inserted_at
    |> Timex.Timezone.convert(Timex.Timezone.local())
    |> Timex.format!("{M}/{D}/{YYYY} {h24}:{m}{am}")
  end
end
