class OrdersController < ApplicationController
  before_action :get_user
  
  def index
    @orders = @user.orders
  end

  def show
    @order = @user.orders.find(params[:id])
  end

  def create
    order = Order.new(order_params)
    @user.orders << order
    response.location = user_order_path(@user, order)
    head 201
  end

  def order_params
    params.permit(:name, :address, :phone)
  end
  private
  def get_user
    @user = User.find(params[:user_id])
  end
end
