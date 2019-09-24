use Mix.Config

config :tweeter, :event_store, stream: "tweeter_test"

# Print only warnings and errors during test
config :logger, level: :warn

# See https://github.com/exponentially/extreme
config :extreme, :event_store,
  db_type: :node,
  host: System.get_env("TWEETER_EVENTSTORE", "localhost"),
  port: 1113,
  username: "admin",
  password: "changeit",
  reconnect_delay: 2_000,
  connection_name: :tweeter,
  max_attempts: :infinity
