defmodule TweeterWeb.Router do
  use TweeterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: TweeterWeb.Schema, json_codec: Jason
  forward "/graphql", Absinthe.Plug, schema: TweeterWeb.Schema, json_codec: Jason

  scope "/", TweeterWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/", PageController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", TweeterWeb do
  #   pipe_through :api
  # end
end
