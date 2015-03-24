note
	description: "Summary description for {ORDERS}."
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

	change_status(o_status:STRING)
	do
		order_status:= o_status
	end

	set_order_id(o_id:INTEGER)
	do
		order_id:= o_id
	end

	get_order_id : INTEGER
	do
		Result:= order_id
	end

	get_order_status : STRING
	do
		Result:= order_status
	end

	get_order_items : STRING
	do
		Result:= ""
		across order_items.domain as it
		loop
			if order_items.domain.at (order_items.domain.count) = it.item  then
				Result.append (it.item.out + "->" + order_items.occurrences (it.item).out)
			else
				Result.append (it.item.out + "->" + order_items.occurrences (it.item).out+ ",")
			end
		end
	end

	get_items_in_bag : MY_BAG[STRING]
	do
		Result:= order_items
	end
end
