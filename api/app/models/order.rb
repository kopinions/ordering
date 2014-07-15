class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :address, type: String
  field :phone, type: String

  belongs_to :user
  embeds_many :order_items

  has_one :payment

  def total_price
    sum = 0
    order_items.each {|item| sum = sum + item.amount}
    sum
  end
end
