defmodule Afterbuy.Client do
  @moduledoc """
  HTTPoison Base extended client for Afterbuy API
  """
  require Logger
  use HTTPoison.Base
  alias Afterbuy.XML.{Decoder, Encoder}

  @default_url "https://api.afterbuy.de/afterbuy/ABInterface.aspx"

  @doc """
  Issues a POST request using default [Afterbuy API URL](#{@default_url}).

  Returns `{:ok, response}` if the request is successful, `{:error, reason}`
  otherwise.

  See `request/5` for more detailed information.
  """
  def post(body, headers \\ [], options \\ []) when is_map(body),
    do: request(:post, nil, body, headers, options)

  def post(url, body, headers, options),
    do: super(url, body, headers, options)

  @doc """
  Issues a POST request using default [Afterbuy API URL](#{@default_url}),
  raising an exception in case of failure.

  If the request does not fail, the response is returned.

  See `request!/5` for more detailed information.
  """
  def post!(body, headers \\ [], options \\ []) when is_map(body),
    do: request!(:post, nil, body, headers, options)

  def post(url, body, headers, options),
    do: super(url, body, headers, options)

  @doc false
  def process_url(""), do: @default_url
  def process_url(nil), do: @default_url
  def process_url(url), do: url

  @doc false
  def process_request_headers(_) do
    [{"Content-Type", "text/xml"}]
  end

  @doc false
  def process_request_body(body) do
    body
    |> Saxy.Builder.build()
    |> Encoder.encode!()
    |> (fn data ->
          Logger.debug(data)
          data
        end).()
  end

  @doc false
  def process_response_body(body) do
    Logger.configure(truncate: :infinity)

    body
    |> (fn data ->
          Logger.debug(data)
          data
        end).()
    |> Decoder.decode!()
  end

  @doc false
  def process_headers(headers), do: headers
  @doc false
  def process_request_options(options), do: options
  @doc false
  def process_response_chunk(chunk), do: chunk
  @doc false
  def process_status_code(status_code), do: status_code
end
