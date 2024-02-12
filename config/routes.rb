# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  get "/admin/orders/:order_id/dhl-label" => "admin/orders#dhl_label"
end
