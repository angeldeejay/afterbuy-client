defmodule Afterbuy.Filter.AfterbuyUserId do
  use Afterbuy.Filter, {:single, []}

  def name, do: "AfterbuyUserID"
end
