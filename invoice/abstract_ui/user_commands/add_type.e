note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class ADD_TYPE
inherit
	ADD_TYPE_INTERFACE
	redefine add_type end
create
	make
feature -- command
	add_type(product_id: STRING)
    	do
			-- perform some update on the model state
			model.add_type (product_id)
			container.on_change.notify ([Current])
    	end

end
