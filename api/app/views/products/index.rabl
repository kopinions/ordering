collection @products
attributes :name, :description

node :uri do |product|
    product_path product
end

node :price do |product|
    product.price.amount
end