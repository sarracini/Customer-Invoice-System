note
	description: "Summary description for {STUDENT_TEST1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST1
inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create stock.make
			create order1.make_empty
			create order2.make_empty
			create bag1.make_empty
			create bag2.make_empty
			add_boolean_case(agent t1)
			add_boolean_case(agent t2)
			add_boolean_case(agent t3)
			add_boolean_case(agent t4)
			add_boolean_case(agent t5)
			add_boolean_case(agent t6)
			add_violation_case(agent v1)
			add_violation_case(agent v2)
			add_violation_case(agent v3)
			add_violation_case(agent v4)
			add_violation_case(agent v5)
		end
feature -- attributes
	stock: STOCK
	order1: ARRAY[TUPLE[STRING,INTEGER]]
	order2: ARRAY[TUPLE[STRING,INTEGER]]
	bag1: MY_BAG[STRING]
	bag2: MY_BAG[STRING]

feature -- tests

	t1: BOOLEAN
	do
		comment("t1: create a type nuts %N")
		stock.create_type("nuts")
		Result:= stock.product.has("nuts")
		check Result end
		sub_comment("stock now contains: " + stock.product.domain[1].out)
		Result:= stock.product_in_stock ("nuts")
		check Result end
	end

	t2: BOOLEAN
	do
		comment("t2: add a quantity to an existing type")
		stock.add_to_stock ("nuts", 100)
		Result:= stock.product.occurrences ("nuts") = 100
		check Result end
		sub_comment("check that an order has not been created")
		Result:= stock.number_of_orders = 0
		check Result end
		sub_comment("check that cart is empty")
		Result:= stock.carts.is_empty = true
		check Result end
	end

	t3: BOOLEAN
	do
		stock.create_type("bolts")
		stock.create_type("hammers")
		stock.add_to_stock ("hammers", 100)
		stock.add_to_stock ("bolts", 100)
		bag1:= <<["nuts", 10]>>
		bag2:= <<["bolts", 10], ["hammers", 10]>>
		order1:= <<["nuts", 10]>>
		order2:= <<["bolts", 10], ["hammers", 10]>>
		comment("t3: adding orders")
		----------------------------process and test order 1
		stock.add_order (order1)
		if attached stock.carts.at (1) as g then
			Result:= g.get_order_status ~ "pending"
			and then stock.get_current_id = 1
			and then stock.number_of_orders = 2
			and then g.get_items_in_bag.bag_equal (bag1)
			and then stock.carts.is_empty = false
		end
		check Result end
		Result:= stock.product.occurrences ("nuts") = 90
		check Result end
		----------------------------process and test order 2
		stock.add_order (order2)
		if attached stock.carts.at (2) as k then
			Result:= k.get_order_status ~ "pending"
			and then stock.get_current_id = 2
			and then stock.number_of_orders = 3
			and then k.get_items_in_bag.bag_equal (bag2)
			and then stock.carts.is_empty = false
			and then stock.product.domain.count = 3
			check Result end
		end
		Result:= stock.product.occurrences ("hammers") = 90 and then stock.product.occurrences ("bolts") = 90
		check Result end
	end

	t4: BOOLEAN
	do
		comment("t4: invoicing")
		Result:= true
	end

	t5: BOOLEAN
	do
		comment("t5: canceling")
		Result:= true
	end

	t6: BOOLEAN
	do
		comment("t6: finding duplicates")
		Result:= true
	end

	v1
	do
		comment("v1: create blank type")
		stock.create_type ("")
	end

	v2
	do
		comment("v2: add to stock with blank type and negative amount")
		stock.add_to_stock ("nuts", -10)
		stock.add_to_stock ("", 10)
	end

	v3
	local
		bag: MY_BAG[STRING]
	do
		create bag.make_empty
		comment("v3: create order must be non empty")
		stock.create_order (bag)
	end

	v4
	local
		order: ARRAY[TUPLE[STRING,INTEGER]]
	do
		create order.make_empty
		comment("v4: add an order must all all fields non-empty")
		stock.add_order (order)
		order:=<<["",-10]>>
		stock.add_order (order)
	end

	v5
	local
		order: ARRAY[TUPLE[STRING,INTEGER]]
	do
		create order.make_empty
		comment("v5: invoicing and canceling with illegal order id")
		stock.do_invoice(-10)
		stock.delete_order (-10)

	end
end
