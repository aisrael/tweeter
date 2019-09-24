use Mix.Config

config :tweeter, :event_store, stream: "tweeter_test"

# Print only warnings and errors during test
config :logger, level: :warn
