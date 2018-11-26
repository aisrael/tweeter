defmodule Tweeter.Repo do
  use Ecto.Repo,
    otp_app: :tweeter,
    adapter: Ecto.Adapters.Postgres
end
