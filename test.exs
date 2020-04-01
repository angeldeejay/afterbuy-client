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

TeslaClient.post!(nil, Request.new(%{global | call_name: "GetShopProducts"}))
TeslaClient.post!("https://www.google.com.co", Request.new(%{global | call_name: "GetShopProducts"}))

# HTTPoisonClient.post!(nil, Request.new(%{global | call_name: "GetShopProducts"}))
# HTTPoisonClient.post!("https://www.google.com.co", Request.new(%{global | call_name: "GetShopProducts"}))
