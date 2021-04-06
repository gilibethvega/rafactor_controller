require 'rails_helper'

RSpec.describe Order, type: :model do
  it "create a successfull order" do
    order = Order.create(id: 1, number: 'BO868276060', total: 7634.98, state: 'pending')
    expect(order).to be_valid
  end
  it "create a invalid order" do
    order = Order.create(id: 1, number: 'BO868276060', total: 7634.98, state: ' ')
    expect(order).to_not be_valid
  end
end

