defmodule Afterbuy do
  @moduledoc """
  Afterbuy client for Elixir

  ## Usage with HTTPoison
      alias Afterbuy.HTTPoison.Client
      alias Afterbuy.Global
      alias Afterbuy.Request

      global = %Global{
        partner_id: "MY-PARTNER-ID",
        partner_token: "MY-PARTNER-TOKEN",
        account_token: "MY-ACCOUNT-TOKEN",
        call_name: nil,
        detail_level: "0",
        error_language: "en"
      }

      request =
        Request.new(%{global | call_name: "MyCallName"})
        |> Request.add_params(%{
          request_all_items: 1,
          order_direction: 0
        })

      response = Client.post!(nil, request)

  ## Usage with Tesla
      alias Afterbuy.Tesla.Client
      alias Afterbuy.Global
      alias Afterbuy.Request

      global = %Global{
        partner_id: "MY-PARTNER-ID",
        partner_token: "MY-PARTNER-TOKEN",
        account_token: "MY-ACCOUNT-TOKEN",
        call_name: nil,
        detail_level: "0",
        error_language: "en"
      }

      request =
        Request.new(%{global | call_name: "MyCallName"})
        |> Request.add_params(%{
          request_all_items: 1,
          order_direction: 0
        })

      response = Client.post!(nil, request)
  """
end
