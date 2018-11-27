defmodule TweeterWeb.PageController do
  use TweeterWeb, :controller

  def index(conn, _params) do
    [ tweet | _ ] =Tweeter.Repo.all(Tweeter.Tweet)
    render(conn, "tweets.html", tweet: tweet, layout: {TweeterWeb.LayoutView, "tweeter.html"})
  end
end
