class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :address, type: String
  field :phone, type: String

  belongs_to :user
end
