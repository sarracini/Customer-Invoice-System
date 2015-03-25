note
	description: ""
	author: "Ursula Sarracini"
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
		local
			m: STATUS_MESSAGE
    	do
    		create m.make_ok
			if m.product_type_non_empty (product_id) then
				create m.make_non_empty_type
				model.set_status_message (m)

			elseif model.stock.product_in_stock (product_id) then
				create m.make_type_in_database
				model.set_status_message (m)

			else
				model.add_type (product_id)
				model.set_status_message (m)
			end

			container.on_change.notify ([Current])
    	end

end
