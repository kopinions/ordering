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

        it 'return order create date' do
          expect(@json[0]["created_at"]).not_to be_nil()
        end
      end
    end
  end

  describe 'GET' do
    context 'with kayla' do
      let!(:kayla){ User.create(name: 'kayla')}
      context 'with one order' do
        let!(:product) {Product.create(name: 'apple', description: 'little apple', price: Price.new(amount: 10))}
        let!(:order_items) {[OrderItem.new(product: product, amount: 20, quantity: 2)]}
        let!(:order){kayla.orders.create(name: 'sofia', address: 'shanghai', phone: '13256784321', order_items: order_items)}
        before {
          get :show, user_id: kayla.id, id: order.id
          @json = JSON.parse(response.body)
        }

        it 'return 200' do
          expect(response).to have_http_status(200)
        end

        it 'return name' do
          expect(@json["name"]).to eq(order.name)
        end

        it 'return address' do
          expect(@json["address"]).to eq(order.address)
        end

        it 'return phone' do
          expect(@json["phone"]).to eq(order.phone)
        end

        it 'return order uri' do
          expect(@json["uri"]).to end_with("/users/#{kayla.id}/orders/#{order.id}")
        end

        it 'return total price' do
          expect(@json["total_price"]).to eq(20)
        end

        it 'return order create date' do
          expect(@json["created_at"]).not_to be_nil()
        end

        it 'return order items' do
          expect(@json["order_items"].length).to eq(1)
        end


        it 'return order item with product' do
          expect(@json["order_items"][0]["product"]).not_to be_nil()
        end

        it 'return order item with product uri' do
          expect(@json["order_items"][0]["product"]["uri"]).to end_with("/products/#{product.id}")
        end

        it 'return order item with amount' do
          expect(@json["order_items"][0]["amount"]).to eq(20)
        end


        it 'return order item with amount' do
          expect(@json["order_items"][0]["amount"]).to eq(20)
        end


        it 'return order item with quantity' do
          expect(@json["order_items"][0]["quantity"]).to eq(2)
        end
      end
    end

  end

  describe 'POST' do
    context 'with kayla' do
      let!(:kayla){ User.create(name: 'kayla')}

      context 'post to create order' do
        before {
          post :create, user_id: kayla.id
        }

        it 'return 201' do
          expect(response).to have_http_status(201)
        end
      end
    end
  end
end
