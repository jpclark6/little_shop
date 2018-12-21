require 'rails_helper'

describe 'As a user' do
  before(:each) do
    @user_1, @user_2 = FactoryBot.create_list(:user, 2)
    @merchant = FactoryBot.create(:merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    @order_1 = @user_1.orders.create(status: 'pending')

    @item_1 = FactoryBot.create(:item)
    @item_2 = FactoryBot.create(:item)

    @order_1.items += [@item_1, @item_2]

    @order_1.order_items.first.update(price: 2, quantity: 3)
    @order_item_1 = @item_1.order_items.first
    @order_1.order_items.last.update(price: 1, quantity: 2)
    @order_item_2 = @item_2.order_items.first

  end
  describe 'when I visit and orders show page' do
    it 'should show the order info and all of the order items' do

      visit profile_order_path(@order_1)

      expect(page).to have_content("Order #{@order_1.id}")
      expect(page).to have_content("Ordered on: #{@order_1.created_at.to_date}")
      expect(page).to have_content("Order updated on: #{@order_1.updated_at.to_date}")
      expect(page).to have_content("Status: #{@order_1.status.titleize}")
      within "#item-#{@item_1.id}" do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_css("img[src='#{@item_1.image}']")
        expect(page).to have_content("Quantity: 3")

        expect(page).to have_content("Price: $#{@order_item_1.price}")
        expect(page).to have_content("Subtotal: $#{@order_item_1.subtotal}")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page).to have_css("img[src='#{@item_2.image}']")

        expect(page).to have_content("Quantity: 2")

        expect(page).to have_content("Price: $#{@order_item_2.price}")
        expect(page).to have_content("Subtotal: $#{@order_item_2.subtotal}")
      end

      expect(page).to have_content("Grand total: $#{@order_1.total_price}")
    end

    xit 'can cancel order if it is still pending' do
      #Justin is doing
      visit profile_order_path(@order_1)
      #cancel order
      expect(false).to eq(true)

      #       As a registered user
      # When I visit an order's show page
      # If the order is still "pending", I see a button or link to cancel the order
      # When I click the cancel button for an order, the following happens:
      # - Each row in the "order items" table is given a status of "unfulfilled"
      # - The order itself is given a status of "cancelled"
      # - Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item.
      # - I am returned to my profile page
      # - I see a flash message telling me the order is now cancelled
      # - And I see that this order now has an updated status of "cancelled"
    end

  end
end
