defmodule TweeterWeb.SchemaTest do
  use TweeterWeb.ConnCase, async: true

  describe "tweet" do
    setup do
      {:ok, tweet} = Tweeter.Tweets.create_tweet(%{handle: "handle", content: "content"})

      [tweet: tweet]
    end

    test "gets a tweet by id", %{conn: conn, tweet: %{id: id}} do
      query = """
      {
        tweet(id: #{id}) {
          id
        }
      }
      """

      response =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert response == %{
               "data" => %{
                 "tweet" => %{
                   "id" => "#{id}"
                 }
               }
             }
    end
  end
end
