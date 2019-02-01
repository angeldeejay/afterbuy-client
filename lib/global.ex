defmodule Afterbuy.Global do
  @moduledoc """
  Authentication global tag
  """
  @derive {Afterbuy.XML.Encoder,
           name: "AfterbuyGlobal",
           children: [
             :partner_id,
             :partner_token,
             :account_token,
             :call_name,
             :detail_level,
             :error_language
           ],
           names: [
             partner_id: "PartnerID"
           ]}

  @enforce_keys [
    :partner_id,
    :partner_token,
    :account_token,
    :call_name,
    :detail_level,
    :error_language
  ]
  defstruct [
    :partner_id,
    :partner_token,
    :account_token,
    :call_name,
    :detail_level,
    :error_language
  ]

  @type t() :: %__MODULE__{}
end
