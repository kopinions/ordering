collection @products
attributes :name, :description

node :uri do |product|
    product_path product
end