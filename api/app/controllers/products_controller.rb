class ProductsController < ApplicationController

  def index
    @products = Product.all()
  end

  def show
    head 200
  end
end
