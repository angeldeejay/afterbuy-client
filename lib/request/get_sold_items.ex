defmodule Afterbuy.Request.GetSoldItems do
  use Afterbuy.Request,
    allowed_params: [
      :request_all_items,
      :max_sold_items,
      :order_direction
    ],
    allowed_filters: [
      :date_filter,
      :order_id,
      :platform,
      :range_id,
      :default_filter_multiple,
      :afterbuy_user_id,
      :user_defined_flag,
      :afterbuy_user_email,
      :shop_id,
      :tag
    ]
end
