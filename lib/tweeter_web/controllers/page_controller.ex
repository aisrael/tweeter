defmodule TweeterWeb.PageController do
  use TweeterWeb, :controller

  def index(conn, _params) do
    render(conn, "tweets.html", layout: {TweeterWeb.LayoutView, "tweeter.html"})
  end
end
