collection @products
attributes :name

node :uri do |product|
    product_path product
end