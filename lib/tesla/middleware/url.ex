defmodule Afterbuy.Tesla.Middleware.Url do
  @moduledoc """
  Validate URL is not nil or empty string

  """

  require Logger

  alias Afterbuy.Tesla.Client.Error, as: TeslaError

  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, _opts) do
    env
    |> validate()
    |> Tesla.run(next)
  end

  defp validate(%Tesla.Env{url: url} = env) when is_function(url),
    do: validate(%{env | url: url.(env)})

  defp validate(env) do
    if is_valid?(env.url) do
      env
    else
      ex = %TeslaError{message: "Invalid URL (#{inspect(env.url)})", env: env}
      Logger.error(Exception.format(:error, ex), location: :afterbuy_client_dependency)
      throw(ex)
    end
  end

  defp is_valid?(url) when url not in [nil, ""] do
    url
    |> URI.parse()
    |> case do
      %{host: nil} -> false
      %{host: ""} -> false
      _ -> true
    end
  end

  defp is_valid?(url), do: false
end
