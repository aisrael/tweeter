defmodule TweeterWeb.PageController do
  use TweeterWeb, :controller

  def index(conn, _params) do
    tweets = Tweeter.Repo.all(Tweeter.Tweet)
    render(conn, "tweets.html", tweets: tweets, layout: {TweeterWeb.LayoutView, "tweeter.html"})
  end

  def format_timestamp(tweet) do
    tweet.inserted_at |>
    Timex.Timezone.convert(Timex.Timezone.local) |>
    Timex.format!("{M}/{D}/{YYYY} {h24}:{m}{am}")
  end
end
