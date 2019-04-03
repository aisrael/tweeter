defmodule RepoHelpers do
  @doc false
  defmacro __using__(opts) do
    quote do
      @doc """
      Returns the next value of the given sequence name, or throws an exception.
      See https://www.postgresql.org/docs/current/functions-sequence.html
      """
      @spec nextval!(String.t()) :: integer | {:error, term()}
      def nextval!(sequence_name) when is_binary(sequence_name) do
        result = __MODULE__.query!("SELECT nextval($1::text::regclass);", ["tweets_id_seq"])

        result.rows
        |> Enum.map(&__MODULE__.load(%{nextval: :integer}, {result.columns, &1}))
        |> Enum.at(0)
        |> Map.get(:nextval)
      end
    end
  end
end
