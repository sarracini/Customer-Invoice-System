note
	description: "Summary description for {STOCK}: This class holds the stock (the full list of products available) and all operations done to the products"
	author: “Ursula Sarracini“
	date: "$Date$"
	revision: "$Revision$"

class
	STOCK
create
	make

feature -- creation features

	make
	do
		create products.make_empty
		create carts.make (0)
		create free_orders.make
		order_count := 1
	end

feature -- attributes
	product: MY_BAG[STRING]
	carts: HASH_TABLE[ORDERS, INTEGER]
	free_orders: SORTED_TWO_WAY_LIST[INTEGER]
	order_count: INTEGER

feature -- commands

	create_type(product_name: STRING)
	do
		product.extend(product_name, 0)
	end

	add_to_stock(product_name: STRING; product_quantity: INTEGER)
	do
		product.extend(product_name, product_quantity)
	end

	remove_from_stock(stock_to_be_delivered: like Current)
	do

	end
	
	create_order(bag:MY_BAG[STRING])
	local
		an_order: ORDERS
	do
		create an_order.make(bag)
		if free_orders.count /=0 then
			an_order.set_order_id (free_orders.min)
		elseif order_count < 10000 then
			an_order.set_order_id (order_count)
			order_count:=order_count+1
		end
		carts.extend (an_order, an_order.get_order_id)
		product.remove_all(bag)
	end
	
	add_order(a_array: ARRAY[TUPLE[product_name: STRING; product_quantity: INTEGER]])
	local
		the_bag: MY_BAG[STRING]
	do
		create the_bag.make_from_tupled_array (a_array)

		if the_bag.is_subset_of(product) then
			create_order(the_bag)
		end
	end

	delete_order(order_id: INTEGER)
	do
	
	end
end
