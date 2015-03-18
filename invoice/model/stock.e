note
	description: "Summary description for {STOCK}: This class holds the stock (the full list of products available) and all operations done to the products"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STOCK
create
	make_single_product

feature -- creation features

	make_single_product
	do
		create product.make(0)
		create order.make
	end

feature -- attributes
	product: HASH_TABLE[INTEGER, STRING]
	order: 	ORDERS

feature -- commands

	create_type(product_name: STRING)
	do
		product.put (0, product_name)
	end

	add_to_stock(product_name: STRING; product_quantity: INTEGER)
	local
		item_val: INTEGER
	do
		if product_in_stock(product_name) then
			item_val := product.item (product_name)
			item_val := product_quantity + item_val
			product.remove (product_name)
			product.put (item_val, product_name)
		end
	end

	remove_from_stock(stock_to_be_delivered: like Current)
	do

	end

	update_quantity(product_name: STRING; new_quantity: INTEGER)
	do
		add_to_stock(product_name, new_quantity)
	end

	add_order(a_array: ARRAY[TUPLE[product_name: STRING; product_quantity: INTEGER]])
	local
		place_order : BOOLEAN
	do
		across a_array as it
			loop
				if product_in_stock(it.item.product_name) then
					if stock_has_enough_quantity(it.item.product_name, it.item.product_quantity) then
						place_order := true
					--	remove_from_stock(a_array)
					end
				end
			end

		if place_order then
			across a_array as it
				loop
					update_quantity(it.item.product_name, (-1)*it.item.product_quantity)
				end
			order.create_order(a_array)
		end
	end

	delete_order(order_id: INTEGER)
	do
		if order.contains(order_id) then
			across order.list_of_orders.at (order_id).a_array2 as it
			loop
				update_quantity(it.item.product_name, it.item.product_quantity)
			end
		end
	end

feature -- queries

	product_in_stock(product_name: STRING) : BOOLEAN
	do
		product.search (product_name)
		if product.found then
			Result:= true
		else
			Result:= false
		end
	end

	stock_has_enough_quantity(product_name: STRING; product_quantity: INTEGER) : BOOLEAN
	do
		product.search (product_name)
		if product_in_stock(product_name) then
			if product.found_item - product_quantity >= 0 then
				Result:= true
			else
				Result:= false
			end
		else
			Result:= false
		end
	end
end
