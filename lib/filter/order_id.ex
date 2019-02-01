defmodule Afterbuy.Filter.OrderId do
  use Afterbuy.Filter, {:single, []}

  def name, do: "OrderID"
end
