defmodule Tweeter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @type start_type() :: :normal | {:takeover, node()} | {:failover, node()}
  @type state() :: term()

  @spec start(start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), state()} | {:error, reason :: term()}
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Tweeter.Repo,
      # Start the endpoint when the application starts
      TweeterWeb.Endpoint
      # Starts a worker by calling: Tweeter.Worker.start_link(arg)
      # {Tweeter.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tweeter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(list(tuple), list(tuple), list(any)) :: :ok
  def config_change(changed, _new, removed) do
    TweeterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
