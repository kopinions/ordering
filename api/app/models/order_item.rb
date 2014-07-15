class OrderItem
  include Mongoid::Document
  include Mongoid::Timestamps
  field :amount, type: Float
  field :quantity, type: Integer
  embedded_in :order

  belongs_to :product
end
