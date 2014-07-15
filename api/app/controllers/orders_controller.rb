class OrdersController < ApplicationController
  before_action :get_user
  
  def index
    @orders = @user.orders
  end

  private
  def get_user
    @user = User.find(params[:user_id])
  end
end
