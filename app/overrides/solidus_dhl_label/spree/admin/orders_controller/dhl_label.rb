# frozen_string_literal: true

module SolidusDhlLabel
  module Spree
    module Admin
      module OrdersController
        module DhlLabel
          def dhl_label
            @order = ::Spree::Order.find_by_number(params[:order_id])
            return redirect_to admin_orders_path if @order.blank?
            begin
              label_url = ::Spree::DhlLabelService.instance.fetch_shipping_label(@order)
              redirect_to label_url, allow_other_host: true 
            rescue Net::HTTPBadResponse => e
              flash[:error] = "#{e}"
              redirect_to "/admin/orders/#{@order.number}/edit"
            end
          end

          ::Spree::Admin::OrdersController.prepend self
        end
      end
    end
  end
end
