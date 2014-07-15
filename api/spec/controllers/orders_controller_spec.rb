require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  render_views
  describe 'GET index' do
    context 'with kayla' do
      let!(:kayla){ User.create(name: 'kayla')}
      context 'with one order' do
        before {
          get :index, user_id: kayla.id
        }

        it 'return 200' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
