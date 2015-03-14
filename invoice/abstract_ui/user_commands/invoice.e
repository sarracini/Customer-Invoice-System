note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class INVOICE
inherit 
	INVOICE_INTERFACE
	redefine invoice end
create
	make
feature -- command 
	invoice(order_id: INTEGER)
    	do
			-- perform some update on the model state
			model.default_update
			container.on_change.notify ([Current])
    	end

end
