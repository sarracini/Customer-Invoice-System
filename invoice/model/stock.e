note
	description: "This class holds the stock (the full list of products available) and all operations done to the products"
	author: "Ursula Sarracini"
	date: "$Date$"
	revision: "$Revision$"

class
	STOCK
create
	make

feature -- creation features

	make
	do
		create product.make_empty
		create carts.make (0)
		create available_orders.make
		create order_id_list.make (0)
		number_of_orders := 1
	end

feature -- attributes
	product: MY_BAG[STRING]
	carts: HASH_TABLE[ORDERS, INTEGER]
	available_orders: TWO_WAY_LIST[INTEGER]
	number_of_orders: INTEGER
	current_id: INTEGER
	order_id_list: ARRAYED_LIST[INTEGER]

feature -- commands

	create_type(product_name: STRING)
		-- Creates a string to represent a 'type' and adds it to the product list
		-- Product has no quantity
	require
		name_non_empty: product_name.count > 0
	do
		product.extend (product_name, 0)
	ensure
		type_added: product.found_item (product_name)
	end

	add_to_stock(product_name: STRING; product_quantity: INTEGER)
		-- Adds the given quantity to the product
	require
		name_non_empty: product_name.count > 0
		positive_quantity: product_quantity > 0
		found_item: product.found_item (product_name)
	do
		product.extend (product_name, product_quantity)
	ensure
		product_added: product.occurrences (product_name) = old product.occurrences (product_name) + product_quantity
	end

	create_order(bag: MY_BAG[STRING])
		-- Create an order from the given bag i.e set unique order id, update list of available order ids and used order ids
	require
		non_empty_order: bag.domain.count > 0
	local
		an_order: ORDERS
	do
		create an_order.make (bag)
		if not available_orders.is_empty then
			an_order.set_order_id (available_orders.first)
			order_id_list.extend (available_orders.first)
			available_orders.search (available_orders.first)
			current_id:= available_orders.first
			available_orders.remove
		elseif number_of_orders < 10000 then
			an_order.set_order_id (number_of_orders)
			order_id_list.extend (number_of_orders)
			current_id:= number_of_orders
			number_of_orders:= number_of_orders + 1
		end
		carts.force (an_order, an_order.get_order_id)
		product.remove_all(bag)
	ensure
		order_id_list_updated: order_id_list.count = old order_id_list.count + 1
	--	product_updated: attached carts.at (current_id) as g and then product.remove_all (g.order_items)
	end

	add_order(a_array: ARRAY[TUPLE[product_name: STRING; product_quantity: INTEGER]])
		-- Add the contents of the passed array to an order i.e create a bag and create an order from that bag
	require
		non_empty_array: a_array.is_empty = false
		product_name_exists: a_array.at (1).product_name.count > 0
		quantity_non_negative: a_array.at (1).product_quantity > 0
		no_dups: verify_duplicates(a_array) = false
	local
		the_bag: MY_BAG[STRING]
	do
		create the_bag.make_from_tupled_array (a_array)
		if the_bag.is_subset_of (product) then
			create_order (the_bag)
		end
	end

	delete_order(order_id: INTEGER)
		-- Deletes an order i.e removes it from the cart, frees up the order id, update order id list
	require
		order_id_positive: order_id >= 0
		order_id_found: order_id_list.has (order_id)
	do
		if attached carts.at(order_id) as g then
			product.add_all (g.get_items_in_bag)
		end
		available_orders.force(order_id)
		order_id_list.search (order_id)
		order_id_list.remove
		order_id_list.start
		carts.remove (order_id)
	ensure
		order_id_list_updated: order_id_list.count = old order_id_list.count - 1
		removed_from_cart: carts.has (order_id) = false
	end

	do_invoice(order_id: INTEGER)
		-- Process an invoice i.e change status from "pending" to "invoiced"
	require
		order_id_positive: order_id >= 0
		order_id_found: order_id_list.has (order_id)
	do
		if attached carts.at (order_id) as g then
			g.change_status("invoiced")
		end
	ensure
		status_changed: attached carts.at (order_id) as g and then
			g.get_order_status ~ "invoiced"
	end

feature -- queries

	product_in_stock(product_name: STRING) : BOOLEAN
		-- Returns true if the product type exists in stock and false otherwise
	require
		product_name_exists: product_name.count > 0
	do
		Result:= product.found_item(product_name)
	end

	verify_duplicates(a_order2: ARRAY[TUPLE[product_name: STRING; product_quantity: INTEGER]]) : BOOLEAN
		-- Verify that the order does not contain duplicates. Returns true if there are duplicates and false otherwise
	require
		array_non_empty: a_order2.is_empty = false
		product_name_exists: a_order2.at (1).product_name.count > 0
		quantity_non_negative: a_order2.at (1).product_quantity > 0
	local
		the_bag:MY_BAG[STRING]
	do
		create the_bag.make_empty
		across a_order2 as it
		loop
			if the_bag.found_item (it.item.product_name) then
				Result:= true
			end
			the_bag.extend (it.item.product_name, it.item.product_quantity)
		end
	end

	valid_id(order_id : INTEGER) : BOOLEAN
		-- Returns true if the order passed is found in the order id list and false otherwise
	require
		order_id_postitive: order_id >= 0
	do
		across order_id_list as it
		loop
			if order_id = it.item then
				Result:= true
			end
		end
	end

	already_invoiced(order_id: INTEGER) : BOOLEAN
		-- Returns true if the order that we are trying to invoice has already been invoiced and false otherwise
	require
		order_id_positive: order_id >= 0
	do
		Result:= false
		if attached carts.at (order_id) as it then
			if it.get_order_status ~ "invoiced" then
				Result:= true
			end
		end
	end

	get_current_id : INTEGER
		-- Returns the current id that is being used when placing an order
	do
		Result:= current_id
	end
end
