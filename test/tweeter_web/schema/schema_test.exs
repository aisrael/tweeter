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

    test "creates a tweet and returns the id", %{conn: conn} do
      query = """
      mutation {
        createTweet(handle: "test", content: "test content") {
          id
        }
      }
      """

      count_before = Tweeter.Tweets.list_tweets() |> Enum.count()

      response =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert %{
               "data" => %{
                 "createTweet" => %{
                   "id" => id
                 }
               }
             } = response

      assert Tweeter.Tweets.list_tweets() |> Enum.count() == count_before + 1

      i = String.to_integer(id)

      assert %Tweeter.Tweet{id: ^i, handle: "test", content: "test content"} =
               Tweeter.Tweets.get_tweet!(id)
    end
  end
end
