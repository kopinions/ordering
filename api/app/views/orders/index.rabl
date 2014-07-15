collection @orders
attributes :name, :address, :phone

node :uri do |order|
    user_order_path @user, order
end

node :total_price do |order|
    order.total_price
end

node :created_at do |order|
    order.created_at
end