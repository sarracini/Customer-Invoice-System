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
    	do
			-- perform some update on the model state
			model.add_product (a_product, quantity)
			container.on_change.notify ([Current])
    	end

end
