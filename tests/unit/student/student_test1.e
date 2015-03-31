note
	description: "Unit Tests for the Customer Invoice System"
	author: "Ursula Sarracini"
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
			create order3.make_empty
			create bag1.make_empty
			create bag2.make_empty
			add_boolean_case(agent t1)
			add_boolean_case(agent t2)
			add_boolean_case(agent t3)
			add_boolean_case(agent t4)
			add_boolean_case(agent t5)
			add_violation_case(agent v1)
			add_violation_case(agent v2)
			add_violation_case(agent v3)
			add_violation_case(agent v4)
			add_violation_case(agent v5)
			add_violation_case(agent v6)
		end
feature -- attributes
	stock: STOCK
	order1: ARRAY[TUPLE[STRING,INTEGER]]
	order2: ARRAY[TUPLE[STRING,INTEGER]]
	order3: ARRAY[TUPLE[STRING,INTEGER]]
	bag1: MY_BAG[STRING]
	bag2: MY_BAG[STRING]


feature -- tests

	t1: BOOLEAN
	do
		comment("t1: creating a type without a quantity")
		stock.create_type("nuts")
		stock.create_type("bolts")
		Result:= stock.product.has("nuts")
		and then stock.product.has ("bolts")
		check Result end
		Result:= stock.product_in_stock ("nuts")
		and then stock.product_in_stock ("bolts")
		and then not stock.product_in_stock ("washers")
		check Result end
		sub_comment("created types 'nuts' and 'bolts'. The stock now contains the following items: " + stock.product.domain[1].out + ", " + stock.product.domain[2].out)
	end

	t2: BOOLEAN
	do
		comment("t2: add a quantity to an existing type")
		stock.add_to_stock ("nuts", 100)
		Result:= stock.product.occurrences ("nuts") = 100
		check Result end
		sub_comment("product added = nuts -> 100")
		sub_comment("check that the stock has been updated to contain 100 nuts")
		Result:= stock.order_id_list.count = 0
		check Result end
		sub_comment("check that an order has not been created i.e cart is still empty and order list count is 0")
		Result:= stock.carts.is_empty
		check Result end
	end

	t3: BOOLEAN
	do
		stock.create_type("hammers")
		stock.add_to_stock ("hammers", 100)
		stock.add_to_stock ("bolts", 100)
		bag1:= <<["nuts", 10]>>
		bag2:= <<["bolts", 10], ["hammers", 10]>>
		order1:= <<["nuts", 10]>>
		order2:= <<["bolts", 10], ["hammers", 10]>>
		comment("t3: creating orders (types and products already added to stock)")
		sub_comment("order 1 = <<[nuts, 10]>> and order 2 = <<[bolts, 10], [hammers, 10]>>")
		----------------------------process and test order 1
		stock.add_order (order1)
		if attached stock.carts.at (1) as g then
			Result:= g.get_order_status ~ "pending"
			and then stock.get_current_id = 1
			and then g.get_items_in_bag.bag_equal (bag1)
			and then stock.carts.is_empty = false
			and then stock.order_id_list.count = 1
			sub_comment("check for order 1 status is pending, current id is 1, cart contains items from order 1 and order list count incremented")
		end
		check Result end
		Result:= stock.product.occurrences ("nuts") = 90
		check Result end
		----------------------------process and test order 2
		stock.add_order (order2)
		if attached stock.carts.at (2) as k then
			Result:= k.get_order_status ~ "pending"
			and then stock.get_current_id = 2
			and then k.get_items_in_bag.bag_equal (bag2)
			and then stock.carts.is_empty = false
			and then stock.product.domain.count = 3
			and then stock.order_id_list.count = 2
			sub_comment("check for order 2 status is pending, current id is 2, cart contains items from order 2 and order list count incremented")
		end
		check Result end
		Result:= stock.product.occurrences ("hammers") = 90 and then stock.product.occurrences ("bolts") = 90
		check Result end
		sub_comment("check stock has been reduced by correct amount of products placed in order")
	end

	t4: BOOLEAN
	do
		comment("t4: invoicing an existing order")
		stock.do_invoice (1)
		if attached stock.carts.at (1) as g then
			Result:= g.get_order_status ~ "invoiced"
		end
		check Result end
		sub_comment("order 1 has been invoiced and check order status has been changed from pending to invoiced")
	end

	t5: BOOLEAN
	do
		comment("t5: cancelling an existing order")
		stock.delete_order (1)
		Result:= stock.order_id_list.count = 1
		and then stock.carts.has (2) = true
		and then stock.carts.has(1) = false
		and then stock.carts.is_empty = false
		check Result end
		sub_comment("order 1 has been deleted and check order id list is decremented, cart no longer contains order 1")
		stock.delete_order (2)
		Result:= stock.carts.is_empty
		and then stock.order_id_list.count = 0
		check Result end
		sub_comment("order 2 has been deleted and check order id list is decremented, cart is now empty")
	end

	v1
	do
		comment("v1: violation case for creating a type with a blank name")
		stock.create_type ("")
	end

	v2
	do
		comment("v2: violation case for adding to the stock with a negative amount, and adding with a blank type")
		stock.add_to_stock ("nuts", -10)
		stock.add_to_stock ("", 10)
	end

	v3
	local
		bag: MY_BAG[STRING]
	do
		create bag.make_empty
		comment("v3: violation case for creating an empty order i.e an order which contains no product types and no quantities")
		stock.create_order (bag)
	end

	v4
	local
		order: ARRAY[TUPLE[STRING,INTEGER]]
	do
		create order.make_empty
		comment("v4: violation case for creating an order with a negative amount, and with blank type name")
		stock.add_order (order)
		order:=<<["",10]>>
		order:=<<["nuts",-10]>>
		stock.add_order (order)
	end

	v5
	local
		order: ARRAY[TUPLE[STRING,INTEGER]]
	do
		create order.make_empty
		comment("v5: violation case for invoicing and cancelling orders with invalid order ids i.e negative and non-existing order ids")
		stock.do_invoice(-10)
		stock.delete_order (-10)
		stock.do_invoice (17)
		stock.delete_order (17)

	end

	v6
	do
		comment("v6: violation case for creating an order with duplicate types")
		sub_comment("i.e order 3 = <<[nuts, 10], [nuts, 70]>>")
		order3:= <<["nuts", 10], ["nuts", 70]>>
		stock.add_order (order3)
	end
end
