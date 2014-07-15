object @order

attribute :name, :address, :phone

node :uri do |order|
    user_order_path @user, order
end

node :total_price do |order|
    order.total_price
end

node :created_at do |order|
    order.created_at
end

node :order_items do |order|
    order.order_items.map do |item|
        {amount: item.amount}
    end
end