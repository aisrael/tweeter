defmodule RepoHelpers do
  @moduledoc """
  Use this in your Ecto Repos to get a `nextval!(sequence_name)` helper
  function (PostgreSQL only).

  For example:

  ```
  defmodule Shore.Repo do
    use Ecto.Repo,
      otp_app: :shore,
      adapter: Ecto.Adapters.Postgres
    use RepoHelpers
  ```

  From then on, you can call e.g. `nextval!("users_id_seq")` to perform
  equivalent of `SELECT nextval('users_id_seq');`
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      @doc """
      Returns the next value of the given sequence name, or throws an exception.
      See https://www.postgresql.org/docs/current/functions-sequence.html
      """
      @spec nextval!(String.t()) :: integer | {:error, term()}
      def nextval!(sequence_name) when is_binary(sequence_name) do
        result = __MODULE__.query!("SELECT nextval($1::text::regclass);", [sequence_name])

        result.rows
        |> Enum.map(&__MODULE__.load(%{nextval: :integer}, {result.columns, &1}))
        |> Enum.at(0)
        |> Map.get(:nextval)
      end
    end
  end
end
