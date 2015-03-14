note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class ADD_ORDER
inherit
	ADD_ORDER_INTERFACE
	redefine add_order end
create
	make
feature -- command
	add_order(a_order: ARRAY[TUPLE[pid: STRING; no: INTEGER]])
    	do
			-- perform some update on the model state
			model.add_order(a_order)
			container.on_change.notify ([Current])
    	end

end
