object @payment
node :uri do
    user_order_path @user, @order
end

node :payment do |payment|
    attributes :amount
end