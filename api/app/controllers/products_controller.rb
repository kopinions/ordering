class ProductsController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :product_not_found

  def index
    @products = Product.all()
  end

  def show
    @product = Product.find(params[:id])
  end

  def create
    product = Product.new(product_params)
    product.save
    head 201
  end

  def product_params
    params.permit(:name, :description)
  end
  private
  def product_not_found
    response.status = 404
  end
end
