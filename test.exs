alias Afterbuy.HTTPoison.Client, as: HTTPoisonClient
alias Afterbuy.Tesla.Client, as: TeslaClient
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
  %{global | call_name: "GetShopProducts"}
  |> Request.new()
  |> Request.add_params(%{
    max_shop_items: 3,
    pagination_enabled: 1,
    page_number: 1
  })
  |> Request.add_filter(:date_filter, %{
    values: ["ModDate"],
    date_from: NaiveDateTime.from_erl!({{2020, 1, 1}, {0, 0, 0}}),
    date_to: NaiveDateTime.utc_now()
  })

TeslaClient.post!(nil, request)
# TeslaClient.post!("https://www.google.com.co", request)

# HTTPoisonClient.post!(nil, request)
# HTTPoisonClient.post!("https://www.google.com.co", request)
