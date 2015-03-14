note
	description: "Summary description for {INVOICE_SYSTEM}."
	author: ""
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
			create stock.make_single_product
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
			s.append ("%N report: "+ status_message)
			s.append ("%N id: "                 )
			s.append ("%N products: "           )
			across stock.product.current_keys as it loop  s.append (it.item.out + ", ") end
			s.append ("%N stock: "              )
			across stock.product.current_keys as it loop  s.append (it.item.out + "->" + stock.product.at (it.item).out) end
			s.append ("%N orders: "             )
			s.append ("%N carts: "              )
			s.append ("%N order_state: "        )
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
		create stock.make_array_of_products (a_order)
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

