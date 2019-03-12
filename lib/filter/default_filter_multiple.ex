defmodule Afterbuy.Filter.DefaultFilterMultiple do
  use Afterbuy.Filter, {:multiple, []}

  def name, do: "DefaultFilter"
end
