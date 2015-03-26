note
	description: "Creates a single order which contains an array of types and associated quantities to be deduced from stock."
	author: "Ursula Sarracini"
	date: "$Date$"
	revision: "$Revision$"

class
	ORDERS
create
	make

feature -- creation features
	make(bag: MY_BAG[STRING])
	do
		create order_items.make_empty
		order_status:= "pending"
		order_id:= 0
		order_items:= bag
	end

feature -- attributes
	order_status: STRING
	order_id: INTEGER
	order_items: MY_BAG[STRING]

feature -- commands

	change_status(o_status: STRING)
		-- Change the status of the current order
	require
		status_exists: o_status.count > 0
	do
		order_status:= o_status
	ensure
		status_changed: order_status /= old order_status
	end

	set_order_id(o_id: INTEGER)
		-- Set the order id to a unique number
	require
		positive_order_id: o_id > 0
	do
		order_id:= o_id
	ensure
		new_order_id: order_id /= old order_id
	end

feature -- queries

	get_order_id : INTEGER
		-- Return the unique order id of the current order
	do
		Result:= order_id
	end

	get_order_status : STRING
		-- Return the order status of the current order
		-- Can be either "pending" or "invoiced"
	do
		Result:= order_status
	end

	get_items_in_bag : MY_BAG[STRING]
		-- Returns all items in the bag
	do
		Result:= order_items
	end

	print_order_items : STRING
		-- Prints items belonging to the order
	do
		Result:= ""
		across order_items.domain as it
		loop
			if order_items.domain.at (order_items.domain.count) = it.item  then
				Result.append (it.item.out + "->" + order_items.occurrences (it.item).out)
			else
				Result.append (it.item.out + "->" + order_items.occurrences (it.item).out + ",")
			end
		end
	end

invariant
	non_empty_status: order_status.count > 0

end
