defmodule Afterbuy.Client do
  @moduledoc """
  HTTPoison Base extended client for Afterbuy API
  """
  require Logger
  use HTTPoison.Base
  alias Afterbuy.XML.{Decoder, Encoder}

  @default_url "https://api.afterbuy.de/afterbuy/ABInterface.aspx"

  @doc false
  def process_url(url) when url in ["", nil], do: @default_url
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
