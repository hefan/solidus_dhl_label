Deface::Override.new(
  virtual_path: "spree/admin/shared/_header",
  name: "dhl_label_button",
  insert_top: ".page-actions",
  text: '
    <% if @order and @order.completed_at? %>
      <li><%= link_to(I18n.t("spree.dhl_label.title"), "/admin/orders/"+@order.number+"/dhl-label", class: "button fa fa-tag") %></li>
    <% end %>
  ',
  disabled: false
)
