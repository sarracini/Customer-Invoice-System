note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class ADD_PRODUCT
inherit
	ADD_PRODUCT_INTERFACE
	redefine add_product end
create
	make
feature -- command
	add_product(a_product: STRING ; quantity: INTEGER)
		local
			m: STATUS_MESSAGE
    	do
    		create m.make_ok
    		if not m.product_positive_quantity (quantity) then
    			create m.make_positive_quantity
    			model.set_status_message (m)
    		elseif not model.stock.product_in_stock (a_product) then
    			create m.make_product_in_database
    			model.set_status_message (m)
    		else
    			model.add_product (a_product, quantity)
    			model.set_status_message (m)
    		end

			container.on_change.notify ([Current])
    	end

end
