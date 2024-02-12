# frozen_string_literal: true

require 'spec_helper'

RSpec.describe "DHL Label button", js: true do
  let!(:order) { FactoryBot.create(:completed_order_with_totals) }
  let(:user) { FactoryBot.create(:admin_user, password: "dhl_test_pass") }

  it "displays a DHL Label button on order pages" do
    visit spree.admin_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "dhl_test_pass"
    click_button "Login"

    click_link order.number

    expect(page).to have_link('DHL Label', href: "/admin/orders/#{order.number}/dhl-label")
  end
end
