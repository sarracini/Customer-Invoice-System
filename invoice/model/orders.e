note
	description: "Summary description for {ORDERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORDERS
create
	make

feature -- creation features
	make
	do
		create list_of_orders.make(0)
		create available_ids.make
	end

feature -- attributes
	list_of_orders: HASH_TABLE[TUPLE[product: STOCK; status: STRING], INTEGER]
	available_ids: SORTED_TWO_WAY_LIST[INTEGER]
	order_id_counter: INTEGER

feature -- commands

	create_order(a_array: ARRAY[TUPLE[product_name: STRING; product_quantity: INTEGER]])
	local
		stock: STOCK
	do
		create stock.make_array_of_products(a_array)
		if available_ids.count /= 0 then
			list_of_orders.put ([stock, "pending"], available_ids.min)
		elseif order_id_counter < 10000 then
			list_of_orders.put ([stock, "pending"], order_id_counter)
			order_id_counter := order_id_counter + 1
		end

	end
end
