require "rails_helper"

describe 'registered user visits their own profile page' do
  it 'shows all profile data except password' do
    user = FactoryBot.create(:user)
    user_2 = FactoryBot.create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path(user)

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)

    expect(page).to_not have_content(user_2.name)
    expect(page).to_not have_content(user_2.email)
  end

  it 'can see a link to edit my profile data' do
    user = FactoryBot.create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path(user)

    click_on 'Edit Profile'

    expect(current_path).to eq(edit_user_path(user))
  end

  xit 'can see order details' do
    user = FactoryBot.create(:user)
    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)
    item_3 = FactoryBot.create(:item)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit item_path(item_1)
    click_button "Add Item"

    visit item_path(item_1)
    click_button "Add Item"

    visit item_path(item_2)
    click_button "Add Item"

    visit item_path(item_3)
    click_button "Add Item"

    visit cart_path
    click_on 'Check out'

    visit item_path(item_2)
    click_button "Add Item"

    visit item_path(item_3)
    click_button "Add Item"

    visit cart_path
    click_on 'Check out'

    binding.pry

    order_1 = Order.all[-2]
    order_2 = Order.all[-1]

    expect(current_path).to eq(profile_path)

    within(".order-#{order_1.id}") do
      expect(page).to have_link(order_1.id)
      expect(page).to have_content(order_1.created_at)
      expect(page).to have_content(order_1.updated_at)
      expect(page).to have_content(order_1.status)
      expect(page).to have_content(order_1.total_item_count)
      expect(page).to have_content(order_1.total_amount)
    end

    within(".order-#{order_2.id}") do
      expect(page).to have_link(order_2.id)
      expect(page).to have_content(order_2.created_at)
      expect(page).to have_content(order_2.updated_at)
      expect(page).to have_content(order_2.status)
      expect(page).to have_content(order_2.total_item_count)
      expect(page).to have_content(order_2.total_amount)
    end

  end

end
