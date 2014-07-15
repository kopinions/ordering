object @payment
node :uri do
    user_order_path @user, @order
end

node :payment do |payment|
    {uri: (payment_user_order_path @user, @order), pay_type: payment.pay_type, amount: payment.amount, created_at: payment.created_at}
end