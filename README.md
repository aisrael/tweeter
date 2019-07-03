# Tweeter

## Development

### Dependencies

Start the services using `docker-compose`

```
docker-compose up -d
```

Verify that the `$DOCKER_HOST` environment variable is set and points to your docker host (`localhost` usually)

### To test EventStore

```
iex -S mix
```

Then

```
alias Extreme.Msg, as: ExMsg
event = %{test: "abc"}

proto_events = [
    ExMsg.NewEvent.new(
      event_id: Extreme.Tools.gen_uuid(),
      event_type: "TestEvent",
      data_content_type: 0,
      metadata_content_type: 0,
      data: :erlang.term_to_binary(event),
      metadata: ""
    )]
write_events = ExMsg.WriteEvents.new(
    event_stream_id: "tweeter",
    expected_version: -2,
    events: proto_events,
    require_master: false
  )
Extreme.execute Tweeter.EventStore, write_events
```

### To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
