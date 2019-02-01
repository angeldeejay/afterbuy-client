defmodule Afterbuy.Param do
  @moduledoc """
  Afterbuy request parameter abstraction

      iex> Afterbuy.Param.new(:max_shop_items, 250)
      %Afterbuy.Param{name: "MaxShopItems", value: 250}
  """
  @type t() :: %__MODULE__{}

  @derive {Afterbuy.XML.Encoder, name: {:attr, "name"}, children: [:value]}

  @enforce_keys [:name, :value]
  defstruct [:name, :value]

  @doc """
  Returns parameter structure to be serialized
  """
  @spec new(String.t(), String.t() | Tuple.t()) :: __MODULE__.t()
  def new(name, value) do
    struct(__MODULE__, %{name: Inflex.camelize(name), value: value})
  end
end
