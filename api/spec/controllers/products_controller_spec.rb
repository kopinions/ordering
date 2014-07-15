require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do
  render_views
  describe 'GET index' do
    context 'with one product' do
      let!(:apple) { Product.create(name: 'apple', description: 'little apple')}

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
    end
  end
end
