require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do
  render_views
  describe 'GET index' do
    context 'with one product' do
      let!(:apple) { Product.create(name: 'apple', description: 'little apple', price: Price.new(amount: 10))}

      before {
        expect(Product).to receive(:all).and_return([apple])
        get :index
        @json = JSON.parse(response.body)
      }

      it 'return 200' do
        expect(response).to have_http_status(200)
      end

      it 'return one product' do
        expect(@json.length).to eq(1)
      end

      it 'contains uri' do
        expect(@json[0]["uri"]).to end_with("/products/#{apple.id}")
      end

      it 'contain name' do
        expect(@json[0]["name"]).to eq(apple.name)
      end

      it 'contain description' do
        expect(@json[0]["description"]).to eq(apple.description)
      end

      it 'contain price' do
        expect(@json[0]["price"]).to eq(apple.price.amount)
      end
    end
  end

  describe 'GET' do
    context 'with apple' do
      let!(:apple) {Product.create(name: 'apple', description: 'little apple', rating: 2, price: Price.new(amount: 10))}
      before {
        get :show, id: apple.id
        @json = JSON.parse(response.body)
      }

      it 'return 200' do
        expect(response).to have_http_status(200)
      end

      it 'contain uri' do
        expect(@json["uri"]).to end_with("/products/#{apple.id}")
      end

      it 'contain name' do
        expect(@json["name"]).to eq(apple.name)
      end

      it 'contain description' do
        expect(@json["description"]).to eq(apple.description)
      end

      it 'contain price' do
        expect(@json["price"]).to eq(apple.price.amount)
      end

      it 'contain rating' do
        expect(@json["rating"]).to eq(apple.rating)
      end
    end

    context 'with out product' do
      before {
        get :show, id: 'productnotexistindatabase'
      }

      it 'return 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
