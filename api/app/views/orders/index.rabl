collection @orders
attributes :name, :address, :phone

node :uri do |order|
    user_order_path @user, order
end