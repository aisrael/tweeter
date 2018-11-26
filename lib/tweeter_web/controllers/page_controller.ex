defmodule TweeterWeb.PageController do
  use TweeterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
