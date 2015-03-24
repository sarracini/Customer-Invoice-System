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
		local
			m: STATUS_MESSAGE
			local_bag: MY_BAG[STRING]
    	do
    		create m.make_ok
    		create local_bag.make_from_tupled_array (a_order)
			if model.stock.order_id_list.count = 10000 then
				create m.make_no_more_ids_left
				model.set_status_message (m)

			elseif a_order.count = 0 then
				create m.make_non_empty_cart
				model.set_status_message (m)

			elseif not across a_order as it all it.item.no > 0 end then
				create m.make_positive_quantity
				model.set_status_message (m)

			elseif not model.stock.product.is_same_items (local_bag) then
				create m.make_products_not_valid
				model.set_status_message (m)

			elseif not local_bag.has_enough_items (model.stock.product) then
				create m.make_not_enough_stock
				model.set_status_message (m)

			elseif model.stock.verify_duplicates(a_order) then
				create m.make_dup_products
				model.set_status_message (m)

			else
				model.add_order(a_order)
				model.set_status_message (m)
			end

			container.on_change.notify ([Current])
    	end

end
