defmodule Afterbuy.Tesla.Middleware.Logger do
  @moduledoc false

  # Heavily based on Tesla's Tesla.Middleware.Logger
  # https://github.com/teamon/tesla/blob/v1.3.3/lib/tesla/middleware/logger.ex

  defmodule Formatter do
    @moduledoc false

    # Heavily based on Tesla's Tesla.Middleware.Logger.Formatter
    # https://github.com/teamon/tesla/blob/v1.3.3/lib/tesla/middleware/logger.ex

    @default_format "$client -> $method $url [$status] ($time ms): $type "
    @keys ~w(client method url type status time)

    @type format :: [atom | binary]

    @spec compile(binary | nil) :: format
    def compile(nil), do: compile(@default_format)

    def compile(binary) do
      ~r/(?<h>)\$[a-z]+(?<t>)/
      |> Regex.split(binary, on: [:h, :t], trim: true)
      |> Enum.map(&compile_key/1)
    end

    defp compile_key("$" <> key) when key in @keys, do: String.to_atom(key)

    defp compile_key("$" <> key),
      do: raise(ArgumentError, "$#{key} is an invalid format pattern.")

    defp compile_key(part), do: part

    @spec format(Tesla.Env.t(), Tesla.Env.result(), integer, format) :: IO.chardata()
    def format(request, response, time, format) do
      Enum.map(format, &output(&1, request, response, time))
    end

    defp output(:type, _, {:ok, %{body: %{"Afterbuy" => %{"CallStatus" => status}}}}, _),
      do: to_string(status)

    defp output(:type, _, {:error, _}, _), do: "error"
    defp output(:client, _, _, _), do: "Afterbuy Client"
    defp output(:method, env, _, _), do: env.method |> to_string() |> String.upcase()
    defp output(:url, env, _, _), do: env.url
    defp output(:status, _, {:ok, env}, _), do: to_string(env.status)
    defp output(:status, _, {:error, reason}, _), do: "error: " <> inspect(reason)
    defp output(:time, _, _, time), do: :io_lib.format("~.3f", [time / 1000])
    defp output(binary, _, _, _), do: binary
  end

  @behaviour Tesla.Middleware

  @config Application.get_env(:tesla, __MODULE__, [])
  @env Mix.env()
  @format Formatter.compile(@config[:format])

  @type log_level :: :info | :warn | :error

  require Logger

  @impl Tesla.Middleware
  def call(env, next, opts) do
    {time, response} = :timer.tc(Tesla, :run, [env, next])
    level = log_level(response, opts)

    if Keyword.get(@config, :debug, true) and @env != :test do
      Logger.log(level, fn -> Formatter.format(env, response, time, @format) end)
      Logger.debug(fn -> debug(env, response, opts) end)
    end

    response
  end

  defp log_level({:error, _}, _), do: :error
  defp log_level({:ok, %{body: %{"Afterbuy" => %{"CallStatus" => "Error"}}}}, _), do: :error
  defp log_level({:ok, %{body: %{"Afterbuy" => %{"CallStatus" => "Warning"}}}}, _), do: :warn

  defp log_level({:ok, env}, opts) do
    case Keyword.get(opts, :log_level) do
      nil ->
        default_log_level(env)

      fun when is_function(fun) ->
        case fun.(env) do
          :default -> default_log_level(env)
          level -> level
        end

      atom when is_atom(atom) ->
        atom
    end
  end

  @spec default_log_level(Tesla.Env.t()) :: log_level
  def default_log_level(env) do
    cond do
      env.status >= 400 -> :error
      env.status >= 300 -> :warn
      true -> :info
    end
  end

  @debug_encrypted_body "(filtered)"
  @debug_no_body "(no body)"
  @debug_stream "[Elixir.Stream]"

  defp debug(
         request,
         {:ok, %{body: %{"Afterbuy" => %{"CallStatus" => status}}} = response},
         opts
       )
       when status in ~w(Error Warning) do
    debug(request, {:error, response.body}, opts)
  end

  defp debug(request, {:ok, response}, _) do
    [
      "\n- Request: ",
      stringify(request.body),
      "\n- Response: ",
      stringify(response.body)
    ]
  end

  defp debug(request, {:error, error}, _) do
    [
      "\nRequest: ",
      stringify(request.body),
      "\nError  : ",
      stringify(error)
    ]
  end

  defp stringify(%Afterbuy.Request{} = body),
    do:
      inspect(%{
        body
        | global:
            Enum.reduce(~w(partner_id partner_token account_token)a, body.global, fn k, acc ->
              Map.put(acc, k, @debug_encrypted_body)
            end)
      })

  defp stringify(nil), do: @debug_no_body
  defp stringify([]), do: @debug_no_body
  defp stringify(%Stream{}), do: @debug_stream
  defp stringify(stream) when is_function(stream), do: @debug_stream

  defp stringify(%Tesla.Multipart{} = mp) do
    [
      "[Tesla.Multipart]\n",
      "boundary: ",
      mp.boundary,
      ?\n,
      "content_type_params: ",
      inspect(mp.content_type_params),
      ?\n
      | Enum.map(mp.parts, &[inspect(&1), ?\n])
    ]
  end

  defp stringify(data) when is_binary(data) or is_list(data), do: data
  defp stringify(term), do: inspect(term)
end
