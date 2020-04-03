defmodule Afterbuy.Tesla.Client do
  use Tesla

  plug(
    Afterbuy.Tesla.Middleware.BaseUrl,
    :tesla |> Application.get_env(__MODULE__) |> Keyword.get(:base_url, "")
  )

  plug(Afterbuy.Tesla.Middleware.Logger)
  plug(Afterbuy.Tesla.Middleware.Xml)
end
