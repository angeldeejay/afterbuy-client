defmodule Afterbuy.Tesla.Client do
  defmodule Error do
    defexception [:env, :message]

    def message(exception) do
      "#{exception.message}: #{inspect(exception.env)}"
    end
  end

  use Tesla

  @default_middlewares [
    Afterbuy.Tesla.Middleware.Logger,
    Afterbuy.Tesla.Middleware.Xml,
    Afterbuy.Tesla.Middleware.Url
  ]

  plug(Afterbuy.Tesla.Middleware.Logger)
  plug(Afterbuy.Tesla.Middleware.Xml)
  plug(Afterbuy.Tesla.Middleware.Url)

  def client(middleware, adapter \\ nil) do
    Tesla.client(@default_middlewares ++ middleware, adapter)
  end
end
