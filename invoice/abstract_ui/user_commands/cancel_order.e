note
	description: ""
	author: "Ursula Sarracini"
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
		local
			m: STATUS_MESSAGE
    	do
			create m.make_ok
			if not model.stock.valid_id(order_id) then
				create m.make_order_id_not_valid
				model.set_status_message (m)

			else
				model.cancel_order (order_id)
				model.set_status_message (m)
			end

			container.on_change.notify ([Current])
    	end

end
