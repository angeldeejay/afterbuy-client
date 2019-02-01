defmodule Afterbuy.Request do
  @moduledoc """
  Afterbuy request caller. Performs XML serialization
  to post to Afterbuy API

      alias Afterbuy.Client
      alias Afterbuy.Global
      alias Afterbuy.Request

      g = %Global{
        partner_id: "my-partner-id",
        partner_token: "my-partner-token",
        account_token: "my-account-token",
        call_name: nil,
        detail_level: "0",
        error_language: "en"
      }

      response =
        Request.new(%{g | call_name: "MyCallName"})
        |> Request.add_params(%{
          request_all_items: 1,
          order_direction: 0
        })
        |> Client.post!()
  """
  @type t() :: %__MODULE__{}

  alias Afterbuy.Global
  alias Afterbuy.Filter
  alias Afterbuy.Param

  @enforce_keys [:global]
  defstruct(global: nil, parameters: [], filters: [])

  @spec new(Afterbuy.Global.t()) :: __MODULE__.t()
  def new(global),
    do: struct(__MODULE__, %{global: global})

  @doc false
  defp get_restriction(%Global{} = g, :params) do
    module = Module.concat([__MODULE__, Map.get(g, :call_name)])
    module.allowed_params()
  end

  defp get_restriction(%Global{} = g, :filters) do
    module = Module.concat([__MODULE__, Map.get(g, :call_name)])
    module.allowed_filters()
  end

  @doc """
  Adds filter data to request structure
  """
  @spec add_filter(__MODULE__.t(), String.t(), Map.t()) :: __MODULE__.t()
  def add_filter(%__MODULE__{} = r, name, data) do
    allowed = get_restriction(r.global, :filters)

    if name in allowed do
      %{r | filters: r.filters ++ [Filter.new(name, data)]}
    else
      raise ArgumentError,
        message:
          "The filter #{name} is invalid. " <>
            "Allowed filters are: #{Enum.join(allowed, ", ")}"
    end
  end

  @doc """
  Adds parameter data to request structure
  """
  @spec add_param(__MODULE__.t(), String.t(), Map.t()) :: __MODULE__.t()
  def add_param(%__MODULE__{} = r, name, data) do
    allowed = get_restriction(r.global, :params)

    if name in allowed do
      %{r | filters: r.filters ++ [Param.new(name, data)]}
    else
      raise ArgumentError,
        message:
          "The param #{name} is invalid. " <>
            "Allowed filters are: #{Enum.join(allowed, ", ")}"
    end
  end

  @doc """
  Adds filters data to request structure based on a nested map
  """
  @spec add_filters(__MODULE__.t(), Map.t()) :: __MODULE__.t()
  def add_filters(%__MODULE__{} = r, %{} = params) do
    Enum.reduce(params, r, fn {name, data}, acc ->
      add_filter(acc, name, data)
    end)
  end

  @doc """
  Adds parameters data to request structure based on a nested map
  """
  @spec add_params(__MODULE__.t(), Map.t()) :: __MODULE__.t()
  def add_params(%__MODULE__{} = r, %{} = params) do
    Enum.reduce(params, r, fn {name, data}, acc ->
      add_param(acc, name, data)
    end)
  end

  @doc false
  defmacro __using__(o) do
    quote bind_quoted: [options: o] do
      Module.register_attribute(__MODULE__, :name, persist: true)
      Module.register_attribute(__MODULE__, :allowed_params, persist: true)
      Module.register_attribute(__MODULE__, :allowed_filters, persist: true)
      module = __MODULE__

      name =
        Keyword.get(
          options,
          :name,
          module
          |> Module.split()
          |> List.last()
        )

      call_name = Inflex.underscore(name)
      allowed_params = Keyword.get(options, :allowed_params, [])
      allowed_filters = Keyword.get(options, :allowed_filters, [])

      @moduledoc """
      Afterbuy restrictions for request call `#{call_name}`
      """

      @name name
      @allowed_params allowed_params
      @allowed_filters allowed_filters

      def name, do: @name
      def allowed_params, do: @allowed_params
      def allowed_filters, do: @allowed_filters
    end
  end

  defimpl Saxy.Builder do
    import Saxy.XML
    alias Saxy.Builder

    def build(%{__struct__: _module} = struct) do
      nodelist = [Builder.build(struct.global)]
      element("Request", [], nodelist)
    end
  end
end
