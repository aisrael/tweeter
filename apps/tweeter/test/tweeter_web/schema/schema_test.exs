defmodule TweeterWeb.SchemaTest do
  use TweeterWeb.ConnCase, async: true

  describe "tweet" do
    test "gets a tweet by id", %{conn: conn} do
      # Ecto.Adapters.SQL.Sandbox.mode(Tweeter.Repo, {:shared, self()})
      # Ecto.Adapters.SQL.Sandbox.allow(Tweeter.Repo, self(), Tweeter.TweetsEventHandler)

      {:ok, tweet} =
        %Tweeter.Tweet{}
        |> Tweeter.Tweet.changeset(%{handle: "handle", content: "content"})
        |> Tweeter.Repo.insert()

      id = tweet.id

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
          uuid
        }
      }
      """

      # count_before = Tweeter.Tweets.list_tweets() |> Enum.count()

      response =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert %{
               "data" => %{
                 "createTweet" => %{
                   "uuid" => id
                 }
               }
             } = response

      :sys.get_state(Tweeter.TweetsEventHandler)

      # TODO End to end testing somehow (need to start _all_ services)

      # assert Tweeter.Tweets.list_tweets() |> Enum.count() == count_before + 1

      # i = String.to_integer(id)

      # assert %Tweeter.Tweet{id: ^i, handle: "test", content: "test content"} =
      #          Tweeter.Tweets.get_tweet!(id)
    end
  end
end
