require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do
  describe 'GET index' do
    context 'with one product' do
      let!(:apple) { Product.create(name: 'apple', description: 'little apple')}

      before {
        get :index
      }

      it 'return 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
