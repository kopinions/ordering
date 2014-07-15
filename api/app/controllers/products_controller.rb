class ProductsController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :product_not_found

  def index
    @products = Product.all()
  end

  def show
    @product = Product.find(params[:id])
  end

  private
  def product_not_found
    response.status = 404
  end
end
