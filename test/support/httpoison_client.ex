defmodule AfterbuyTest.HTTPoison.Client do
  @moduledoc """
  Mock proxy module
  """
  use HTTPoison.Base
  alias Afterbuy.HTTPoison.Client
  alias Afterbuy.XML.Decoder
  alias HTTPoison.Request
  alias HTTPoison.Response

  @doc false
  def process_request_headers(headers) do
    Client.process_request_headers(headers)
  end

  @doc false
  def process_request_body(body) do
    Client.process_request_body(body)
  end

  @doc false
  def process_response_body(body) do
    Client.process_response_body(body)
  end

  defp request_body_validate(body) do
    try do
      Decoder.decode!(body)
      :ok
    rescue
      ex ->
        require Logger
        Logger.error(ex)
        raise inspect(ex)
    end
  end

  def request(%Request{} = request) do
    request.body
    |> process_request_body()
    |> request_body_validate()

    contents =
      __DIR__
      |> Path.join("..")
      |> Path.join("mock_data")
      |> Path.join([request.url, ".xml"])
      |> File.read!()

    {
      :ok,
      %Response{
        status_code: 200,
        headers: [],
        body: process_response_body(contents),
        request: request,
        request_url: request.url
      }
    }
  end

  def request(method, url, body \\ "", headers \\ [], options \\ []),
    do: super(method, url, body, headers, options)
end
