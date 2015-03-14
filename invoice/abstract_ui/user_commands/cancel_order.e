note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class CANCEL_ORDER
inherit 
	CANCEL_ORDER_INTERFACE
	redefine cancel_order end
create
	make
feature -- command 
	cancel_order(order_id: INTEGER)
    	do
			-- perform some update on the model state
			model.default_update
			container.on_change.notify ([Current])
    	end

end
