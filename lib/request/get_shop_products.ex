defmodule Afterbuy.Request.GetShopProducts do
  use Afterbuy.Request,
    allowed_params: [
      :max_shop_items,
      :suppress_base_product_related_data,
      :pagination_enabled,
      :page_number,
      :return_shop20_container
    ],
    allowed_filters: [
      :product_id,
      :anr,
      :ean,
      :tag,
      :default_filter,
      :level,
      :range_id,
      :range_anr,
      :date_filter,
      :default_filter_multiple
    ]
end
