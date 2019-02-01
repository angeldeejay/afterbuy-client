defmodule Afterbuy.Filter.RangeAnr do
  use Afterbuy.Filter, {:none, [:value_from, :value_to]}
end
