note
	description: "Main invoice system."
	author: "Ursula Sarracini"
	date: "$Date$"
	revision: "$Revision$"

class
	INVOICE_SYSTEM

inherit
	ANY
	redefine out end

create {INVOICE_SYSTEM_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create stock.make
			create status_message.make_ok
			i := 0
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	stock: STOCK
	status_message: STATUS_MESSAGE

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
			create s.make_from_string ("default model state ")
			s.append ("(")
			s.append (i.out)
			s.append (")")
		end

feature -- queries
	out : STRING
	local
		domain_count: INTEGER
		last_position: INTEGER
		do
			s:= ""
			----------------------------------------- report display
			s.append ("  report:      "+ status_message.out)

			----------------------------------------- id display
			domain_count:= 1
			s.append ("%N  id:          " + stock.current_id.out)

			---------------------------------------- products display
			s.append ("%N  products:   ")
			domain_count:= 1
			if stock.product.domain.count > 0 then
				s.append (" ")
			end
			across stock.product.domain as it
			loop
				if domain_count /= stock.product.domain.count then
					s.append (it.item.out + ",")
				else
					s.append (it.item.out)
				end
				domain_count:= domain_count + 1
			end

			---------------------------------------- stock display
			s.append ("%N  stock:       ")
			domain_count:= 1
			across stock.product.domain as it
			loop
				if stock.product.occurrences (it.item) > 0 then
					last_position:= domain_count
				end
				domain_count:= domain_count + 1
			end

			across stock.product.domain as it
			loop
				if stock.product.occurrences (it.item) > 0 then
					if stock.product.domain.at (last_position) = it.item then
						s.append (it.item.out + "->" + stock.product.occurrences (it.item).out)
					else
						s.append (it.item.out + "->" + stock.product.occurrences (it.item).out + ",")
					end
				end
			end

			----------------------------------------- orders display
			s.append ("%N  orders:      ")
			domain_count:= 1
			across stock.order_id_list as it
			loop
				if domain_count /= stock.order_id_list.count then
					s.append (it.item.out + ",")
				else
					s.append (it.item.out)
				end
				domain_count:= domain_count + 1
			end

			------------------------------------------- carts display
			s.append ("%N  carts:       ")
			across stock.order_id_list as it loop
				if attached stock.carts.at (it.item) as g then
					s.append (g.get_order_id.out + ": ")
					if stock.order_id_list.at (stock.order_id_list.count) = it.item then
						s.append (g.get_order_items)
					else
						s.append (g.get_order_items + "%N               ")
					end
				end
			end

			-------------------------------------------- order state display
			s.append ("%N  order_state: ")
			domain_count:= 1
			across stock.order_id_list as it
			loop
				if attached stock.carts.at (it.item) as g then
					if domain_count /= stock.order_id_list.count then
						s.append (g.get_order_id.out + "->" + g.get_order_status + ",")
					else
						s.append (g.get_order_id.out + "->" + g.get_order_status)
					end
					domain_count:= domain_count + 1
				end
			end

			--------------------------------------------- final output display
			Result:= s
		end

feature -- commands
	nothing
	do

	end

	add_type(product_name: STRING)
	require
		not status_message.product_type_non_empty (product_name)
		not stock.product_in_stock (product_name)
	do
		stock.create_type (product_name)
	end

	add_product(a_product: STRING; a_quantity: INTEGER)
	require
		status_message.product_positive_quantity (a_quantity)
		stock.product_in_stock (a_product)
	do
		stock.add_to_stock (a_product, a_quantity)
	end

	add_order(a_order: ARRAY[TUPLE[product_name: STRING; product_quantity: INTEGER]])
	require
		a_order.is_empty = false
		stock.order_id_list.count < 10000
		not stock.verify_duplicates(a_order)
		across a_order as it all it.item.product_quantity > 0 end
		stock.product.is_same_items (create{MY_BAG[STRING]}.make_from_tupled_array (a_order))
		(create{MY_BAG[STRING]}.make_from_tupled_array (a_order)).has_enough_items(stock.product)
	do
		stock.add_order (a_order)
	end

	invoice(order_id: INTEGER)
	require
		stock.valid_id(order_id)
		not stock.already_invoiced(order_id)
	do
		stock.do_invoice (order_id)
	end

	cancel_order(order_id: INTEGER)
	require
		stock.valid_id(order_id)
	do
		stock.delete_order (order_id)
	end

	set_status_message(m: STATUS_MESSAGE)
	do
		status_message := m
	end
end

