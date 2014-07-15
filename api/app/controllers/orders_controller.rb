class OrdersController < ApplicationController
  before_action :get_user
  before_action :set_order, only: [:payment, :show]
  rescue_from Mongoid::Errors::DocumentNotFound, with: :order_not_found


  def index
    @orders = @user.orders
  end

  def show

  end

  def create
    order_items = order_items_params.map do |item|
      product = Product.find(item[:product_id])
      quantity = item[:quantity].to_i
      amount = quantity * product.price.amount
      order_item = OrderItem.new(product: product, quantity: quantity, amount: amount)
    end
    order = Order.new(order_params)
    order.order_items << order_items
    @user.orders << order
    response.location = user_order_path(@user, order)
    head 201
  end


  def payment
    if request.method == "POST"
      payment = Payment.new(params.permit(:pay_type, :amount))
      @order.payment = payment
      response.location = payment_user_order_path @user, @order
      return head 201
    end
    if @order.payment.nil?
      return head 404
    end
    @payment = @order.payment
  end

  def order_params
    params.permit(:name, :address, :phone)
  end

  def order_items_params
    params.permit(order_items: [:product_id, :quantity])[:order_items]
  end

  private
  def set_order
    @order = @user.orders.find(params[:id])
  end

  private
  def get_user
    @user = User.find(params[:user_id])
  end

  def order_not_found
    response.status = 404
  end
end
