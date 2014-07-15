class Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :pay_type, type: String
  field :amount, type: Float

  belongs_to :order
end
