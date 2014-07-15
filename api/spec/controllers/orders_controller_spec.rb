require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  render_views
  describe 'GET index' do
    context 'with kayla' do
      let!(:kayla){ User.create(name: 'kayla')}
      context 'with one order' do
        let!(:order){kayla.orders.create(name: 'sofia', address: 'shanghai', phone: '13256784321')}
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
      end
    end
  end
end
