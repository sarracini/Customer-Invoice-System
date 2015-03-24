note
	description: "Summary description for {STOCK}: This class holds the stock (the full list of products available) and all operations done to the products"
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
		create free_orders.make
		create order_id_list.make (0)
		order_count := 1
	end

feature -- attributes
	product: MY_BAG[STRING]
	carts: HASH_TABLE[ORDERS, INTEGER]
	free_orders: SORTED_TWO_WAY_LIST[INTEGER]
	order_count: INTEGER
	current_id: INTEGER
	order_id_list:ARRAYED_LIST[INTEGER]

feature -- commands

	create_type(product_name: STRING)
	do
		product.extend(product_name, 0)
	end

	add_to_stock(product_name: STRING; product_quantity: INTEGER)
	do
		product.extend (product_name, product_quantity)
	end

	create_order(bag:MY_BAG[STRING])
	local
		an_order: ORDERS
	do
		create an_order.make(bag)
		if free_orders.count /=0 then
			an_order.set_order_id (free_orders.min)
			order_id_list.extend (free_orders.min)
			free_orders.search (free_orders.min)
			current_id:= free_orders.min
			free_orders.remove
		elseif order_count < 10000 then
			an_order.set_order_id (order_count)
			order_id_list.extend (order_count)
			current_id:= order_count
			order_count:= order_count + 1
		end
		carts.force (an_order, an_order.get_order_id)
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
	local
		i:INTEGER
	do
		carts.search(order_id)
		if carts.found then
			if attached carts.found_item as g then
				product.add_all (g.get_items_in_bag)
			end
		end
		free_orders.force(order_id)
		order_id_list.search (order_id)
		order_id_list.remove
		carts.remove (order_id)
	end

	do_invoice(order_id: INTEGER)
	do
		carts.search (order_id)
		if carts.found then
			if attached carts.found_item as g then
				g.change_status("invoiced")
			end
		end
	end

	product_in_stock(product_name: STRING) : BOOLEAN
	do
		Result:= product.found_item (product_name)
	end

	verify_duplicates(a_order2: ARRAY[TUPLE[pid: STRING; no: INTEGER]]) : BOOLEAN
		local
			the_bag:MY_BAG[STRING]
		do
			Result:= false
			create the_bag.make_empty
			across a_order2 as it
			loop
				if the_bag.found_item (it.item.pid) then
					Result:= true
				end
				the_bag.extend (it.item.pid, it.item.no)
			end
		end

	valid_id(order_id : INTEGER) : BOOLEAN
	do
		Result:=false
		across order_id_list as it
		loop
			if order_id = it.item then
				Result:=true
			end
		end
	end

	already_invoiced(order_id:INTEGER) : BOOLEAN
	do
		Result:=false
		if attached carts.at (order_id) as z then
			if z.get_order_status ~ "invoiced" then
				Result:=true
			end
		end
	end

	get_current_id : INTEGER
	do
		Result:= current_id
	end
end
