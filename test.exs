alias Afterbuy.Client
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

# Client.post!("https://www.google.com.co", Request.new(%{global | call_name: "GetShopProducts"}))
Client.post!(Request.new(%{global | call_name: "GetShopProducts"}))
