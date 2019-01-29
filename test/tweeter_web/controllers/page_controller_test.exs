defmodule TweeterWeb.PageControllerTest do
  use TweeterWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Tweeter"
  end
end
