note
	description: ""
	author: "Ursula Sarracini"
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
		local
			m: STATUS_MESSAGE
    	do
			create m.make_ok
			if not model.stock.valid_id(order_id) then
				create m.make_order_id_not_valid
				model.set_status_message (m)

			elseif model.stock.already_invoiced(order_id) then
				create m.make_order_already_invoiced
				model.set_status_message (m)

			else
				model.invoice(order_id)
				model.set_status_message (m)
			end

			container.on_change.notify ([Current])
    	end

end
