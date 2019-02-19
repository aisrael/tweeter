defmodule Tweeter.Repo do
  use Ecto.Repo,
    otp_app: :tweeter,
    adapter: Ecto.Adapters.Postgres

  @spec init(:supervisor | :runtime, config :: Keyword.t()) :: {:ok, Keyword.t()} | :ignore
  def init(_type, config) do
    if database_url = System.get_env("DATABASE_URL") do
      {:ok, Keyword.put(config, :url, database_url)}
    else
      repo_hostname =
        System.get_env("TWEETER_PG_HOSTNAME") ||
          if docker_host = System.get_env("DOCKER_HOST"),
            do: URI.parse(docker_host).host,
            else: "localhost"

      new_config = [
        database: System.get_env("TWEETER_DATABASE") || "tweeter",
        username: System.get_env("TWEETER_PG_USERNAME") || "postgres",
        password: System.get_env("TWEETER_PG_PASSWORD") || "postgres",
        hostname: repo_hostname,
        port: System.get_env("TWEETER_PG_PORT") || "5432"
      ]

      {:ok, Keyword.merge(config, new_config)}
    end
  end
end
