use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tweeter, TweeterWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

repo_hostname =
  if docker_host = System.get_env("DOCKER_HOST"),
    do: URI.parse(docker_host).host,
    else: "localhost"

# Configure your database
config :tweeter, Tweeter.Repo,
  username: "postgres",
  password: "postgres",
  database: "tweeter_test",
  hostname: repo_hostname,
  pool: Ecto.Adapters.SQL.Sandbox
