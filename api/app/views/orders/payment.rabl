object @payment
node :uri do
    user_order_path @user, @order
end

node :payment do |payment|
    {uri: (payment_user_order_path @user, @order)}
end