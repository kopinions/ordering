class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  field :amount, type: Float
  field :effect_date, type: DateTime

  embedded_in :product
end
