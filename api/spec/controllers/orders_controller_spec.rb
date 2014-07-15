require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  render_views
  describe 'GET index' do
    context 'with kayla' do
      let!(:kayla){ User.create(name: 'kayla')}
      context 'with one order' do
        let!(:product) {Product.create(name: 'apple', description: 'little apple', price: Price.new(amount: 10))}
        let!(:order_items) {[OrderItem.new(product: product, amount: 20, quantity: 2)]}
        let!(:order){kayla.orders.create(name: 'sofia', address: 'shanghai', phone: '13256784321', order_items: order_items)}
        before {
          get :index, user_id: kayla.id
          @json = JSON.parse(response.body)
        }

        it 'return 200' do
          expect(response).to have_http_status(200)
        end

        it 'return one order' do
          expect(@json.length).to eq(1)
        end

        it 'return name' do
          expect(@json[0]["name"]).to eq(order.name)
        end

        it 'return address' do
          expect(@json[0]["address"]).to eq(order.address)
        end

        it 'return phone' do
          expect(@json[0]["phone"]).to eq(order.phone)
        end

        it 'return order uri' do
          expect(@json[0]["uri"]).to end_with("/users/#{kayla.id}/orders/#{order.id}")
        end

        it 'return total price' do
          expect(@json[0]["total_price"]).to eq(20)
        end
      end
    end
  end
end
