defmodule Afterbuy.Filter.ProductId do
  use Afterbuy.Filter, {:single, []}

  def name, do: "ProductID"
end
