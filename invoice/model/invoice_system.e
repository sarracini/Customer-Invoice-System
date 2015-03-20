note
	description: "Summary description for {INVOICE_SYSTEM}."
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
			i := 0
			create stock.make
			create status_message.make_ok
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
		domain_count:INTEGER
		do
			s:= ""
			----------------------------------------- report
			s.append ("report: %T"+ status_message.out)
			domain_count:= 1
			if stock.order_id_list.count /= 0 then
				s.append ("%N id: %T%T" + stock.order_id_list.last.out)
			else
				s.append ("%N id: %T%T0")
			end

			---------------------------------------- products
			s.append ("%N products: %T")
			domain_count:= 1
			across stock.product.domain as it
			loop
				if domain_count /= stock.product.domain.count then
					s.append (it.item.out + ",")
				else
					s.append (it.item.out)
				end
				domain_count:= domain_count + 1
			end

			---------------------------------------- stock
			s.append ("%N stock: %T")
			domain_count:= 1
			across stock.product.domain as it
			loop
				if stock.product.occurrences (it.item) > 0 then
					if domain_count /= stock.product.domain.count then
						s.append (it.item.out + "->" + stock.product.occurrences (it.item).out + ",")
					else
						s.append (it.item.out + "->" + stock.product.occurrences (it.item).out)
					end
				domain_count:= domain_count + 1
				end
			end

			----------------------------------------- orders
			s.append ("%N orders: %T")
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

			------------------------------------------- carts		
			s.append ("%N carts: %T")
			across stock.order_id_list as it loop
				if attached stock.carts.at (it.item) as g then
					s.append (g.get_order_id.out + ": ")
					s.append (g.get_order_items + "%N%T%T")
				end
			end

			-------------------------------------------- order state
			s.append ("%N order_state: %T")
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

			--------------------------------------------- final output
			Result:= s
		end

feature -- commands
	nothing
	do

	end

	add_type(product_name: STRING)
	do
		stock.create_type(product_name)
	end

	add_product(a_product: STRING; a_quantity: INTEGER)
	do
		stock.add_to_stock (a_product, a_quantity)
	end

	add_order(a_order: ARRAY[TUPLE[product_name: STRING; product_quantity: INTEGER]])
	do
		stock.add_order(a_order)
	end

	invoice(order_id: INTEGER)
	do
		stock.do_invoice(order_id)
	end

	cancel_order(order_id: INTEGER)
	do
		stock.delete_order (order_id)
	end

	set_status_message(m: STATUS_MESSAGE)
	do
		status_message := m
	end
end

