defmodule Afterbuy.Filter.RangeId do
  use Afterbuy.Filter, {:none, [:value_from, :value_to]}

  def name, do: "RangeID"
end
