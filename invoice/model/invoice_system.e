note
	description: "Summary description for {INVOICE_SYSTEM}."
	author: “Ursula Sarracini”
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
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	stock: STOCK

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
		do
			s:=""
			s.append ("%N report: %T"+ status_message)
			s.append ("%N id: %T")
			s.append (stock.order_count.out)
			s.append ("%N products: %T")
			across stock.products.domain as z
			loop
				s.append (z.item.out + "-> " + stock.products.occurrences (z.item).out)
				s.append (" ")
			end
			s.append ("%N orders: %T")
			s.append (stock.carts.current_keys.count.out)
			s.append ("%N carts: %T")
			across stock.carts.current_keys as z
			loop
				if attached stock.carts.at (z.item) as g then
					s.append (g.get_order_id.out + ":")
					s.append (g.get_order_items)
				end
			end
			s.append ("%N order_state: %T")
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

	end

	cancel_order(order_id: INTEGER)
	do
		
	end

	status_message : STRING
	do
		Result:="ok"
	end
end

