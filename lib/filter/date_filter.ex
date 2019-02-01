defmodule Afterbuy.Filter.DateFilter do
  use Afterbuy.Filter, {:multiple, [:date_from, :date_to]}
end
