defmodule AfterbuyTest.Client.HTTPoisonTest do
  use ExUnit.Case
  doctest Afterbuy

  alias AfterbuyTest.HTTPoison.Client
  alias Afterbuy.Global
  alias Afterbuy.Request

  setup do
    global = %Global{
      partner_id: "MY-PARTNER-ID",
      partner_token: "MY-PARTNER-TOKEN",
      account_token: "MY-ACCOUNT-TOKEN",
      call_name: nil,
      detail_level: "0",
      error_language: "en"
    }

    {:ok, global: global}
  end

  test "success call", %{global: global} do
    response =
      "success_call_name"
      |> Client.post!(Request.new(%{global | call_name: "success_call_name"}))
      |> Map.get(:body)
      |> Map.get("Afterbuy")

    assert response["CallStatus"] == "Success"

    response
    |> Map.get("Result")
    |> Map.has_key?("Products")
    |> assert
  end

  test "warning call", %{global: global} do
    response =
      "warning_call_name"
      |> Client.post!(Request.new(%{global | call_name: "warning_call_name"}))
      |> Map.get(:body)
      |> Map.get("Afterbuy")

    assert response["CallStatus"] == "Warning"

    response
    |> Map.get("Result")
    |> Map.has_key?("WarningList")
    |> assert
  end

  test "error call", %{global: global} do
    response =
      "error_call_name"
      |> Client.post!(Request.new(%{global | call_name: "error_call_name"}))
      |> Map.get(:body)
      |> Map.get("Afterbuy")

    assert response["CallStatus"] == "Error"

    response
    |> Map.get("Result")
    |> Map.has_key?("ErrorList")
    |> assert
  end
end
