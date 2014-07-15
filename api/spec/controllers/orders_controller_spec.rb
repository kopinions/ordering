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
        context 'get with json' do
          before {
            get :index, user_id: kayla.id, format: :json
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

        context 'get with xml' do
          before {
            get :index, user_id: kayla.id, format: :xml
            @xml = Hash.from_xml(response.body)
          }

          it 'return 200' do
            expect(response).to have_http_status(200)
          end

          it 'return orders' do
            expect(@xml["orders"].length).to eq(1)
          end
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

      context 'without order' do
        before {
          get :show, user_id: kayla.id, id: 'notexistorderindatabase'
        }

        it 'return 404' do
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'without user' do
      before {
        get :show, user_id: "notexistuserindatabase", id: 'notexistorderindatabase'
      }

      it 'return 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST' do
    context 'with kayla' do
      let!(:kayla){ User.create(name: 'kayla')}

      context 'with apple' do
        let!(:apple) {Product.create(name: 'apple', description: 'little apple', price: Price.new(amount: 10))}

        context 'post to create order' do
          before {
            expect(Order).to receive(:new).with({"name"=> "sofia", "address" => "chengdu", "phone" => "13898766789"}).and_call_original
            expect(OrderItem).to receive(:new).with(hash_including({quantity: 2, amount: 20.0})).and_call_original
            expect {
              post :create, user_id: kayla.id, name: 'sofia', address: 'chengdu', phone: '13898766789', order_items: [{product_id: apple.id, quantity: 2}]
            }.to change{kayla.orders.count}
          }

          it 'return 201' do
            expect(response).to have_http_status(201)
          end

          it 'return uri of create order' do
            expect(response.header['Location']).to match(%{/users/#{kayla.id}/orders/.*{25}})
          end
        end
      end
    end
  end

  describe 'Payment' do
    context 'with kayla' do
      let!(:kayla){ User.create(name: 'kayla')}
      context 'with order' do
        let!(:product) {Product.create(name: 'apple', description: 'little apple', price: Price.new(amount: 10))}
        let!(:order_items) {[OrderItem.new(product: product, amount: 20, quantity: 2)]}
        let!(:order){kayla.orders.create(name: 'sofia', address: 'shanghai', phone: '13256784321', order_items: order_items)}
        context 'with payment' do
          let!(:payment) {order.create_payment(pay_type: 'CASH', amount: 20)}
          context 'get payment' do
            before {
              get :payment, user_id: kayla.id, id: order.id
              @json = JSON.parse(response.body)
            }

            it 'return 200' do
              expect(response).to have_http_status(200)
            end

            it 'return order uri' do
              expect(@json["uri"]).to end_with("/users/#{kayla.id}/orders/#{order.id}")
            end

            it 'return payment' do
              expect(@json["payment"]).not_to be_nil
            end

            it 'return payment uri' do
              expect(@json["payment"]["uri"]).to end_with("/users/#{kayla.id}/orders/#{order.id}/payment")
            end

            it 'return payment pay type' do
              expect(@json["payment"]["pay_type"]).to eq(payment.pay_type)
            end

            it 'return payment amount' do
              expect(@json["payment"]["amount"]).to eq(payment.amount)
            end

            it 'return payment created at' do
              expect(@json["payment"]["created_at"]).not_to be_nil
            end
          end

          context 'post payment' do
            before {
              expect {
                post :payment, user_id: kayla.id, id: order.id, pay_type: "CASH", amount: 20
              }.not_to change{ Payment.count}
            }

            it 'return 400' do
              expect(response).to have_http_status(400)
            end
          end
        end

        context 'without payment' do
          context 'create payment' do
            before {
              expect(Payment).to receive(:new).with("pay_type" => "CASH", "amount"=> "20").and_call_original
              expect {
                post :payment, user_id: kayla.id, id: order.id, pay_type: "CASH", amount: 20
              }.to change{Payment.count}
            }

            it 'return 200' do
              expect(response).to have_http_status(201)
            end

            it 'return uri of create payment' do
              expect(response.header['Location']).to end_with("/users/#{kayla.id}/orders/#{order.id}/payment")
            end
          end

          context 'get payment' do
            before {
              get :payment, user_id: kayla.id, id: order.id
            }

            it 'return 404' do
              expect(response).to have_http_status(404)
            end
          end
        end
      end
    end
  end
end
