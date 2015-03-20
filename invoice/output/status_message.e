note
	description: "Error messages for invoice system."
	author: “Ursula Sarracini“
	date: "$Date$"
	revision: "$Revision$"

class
	STATUS_MESSAGE
inherit
	ANY

	redefine out end

create
	make_ok,
	make_non_empty_type,
	make_type_in_database,
	make_positive_quantity,
	make_product_in_database,
	make_no_more_ids_left,
	make_non_empty_cart,
	make_products_not_valid,
	make_dup_products,
	make_not_enough_stock,
	make_order_id_not_valid,
	make_order_already_invoiced

feature{NONE}
	make_ok
	do
		err_code := err_ok
	end

	make_non_empty_type
	do
		err_code := err_non_empty_type
	end

	make_type_in_database
	do
		err_code := err_type_in_db
	end

	make_positive_quantity
	do
		err_code := err_positive_quantity
	end

	make_product_in_database
	do
		err_code := err_product_in_db
	end

	make_no_more_ids_left
	do
		err_code := err_no_more_ids_left
	end

	make_non_empty_cart
	do
		err_code := err_non_empty_cart
	end

	make_products_not_valid
	do
		err_code := err_product_not_valid
	end

	make_dup_products
	do
		err_code := err_dup_prods
	end

	make_not_enough_stock
	do
		err_code := err_not_enough_stock
	end

	make_order_id_not_valid
	do
		err_code := err_order_id_not_valid
	end

	make_order_already_invoiced
	do
		err_code := err_order_already_invoiced
	end

feature
	out : STRING
	do
		Result:= err_message [err_code]
	end

feature
	err_code: INTEGER
	err_message: ARRAY[STRING]
		once
			create Result.make_filled ("", 1, 12)
			Result.put("ok",1)
			Result.put ("product type must be non-empty string", 2)
			Result.put("product type already in database", 3)
			Result.put ("quantity added must be positive", 4)
			Result.put ("product not in database", 5)
			Result.put ("no more order ids left", 6)
			Result.put ("cart must be non-empty", 7)
			Result.put ("some products in order not valid", 8)
			Result.put ("duplicate products in order array", 9)
			Result.put ("not enough in stock", 10)
			Result.put ("order id is not valid", 11)
			Result.put ("order already invoiced", 12)
		end

	err_ok : INTEGER = 1
	err_non_empty_type: INTEGER = 2
	err_type_in_db : INTEGER = 3
	err_positive_quantity : INTEGER = 4
	err_product_in_db : INTEGER = 5
	err_no_more_ids_left : INTEGER = 6
	err_non_empty_cart : INTEGER = 7
	err_product_not_valid : INTEGER = 8
	err_dup_prods : INTEGER = 9
	err_not_enough_stock : INTEGER = 10
	err_order_id_not_valid : INTEGER = 11
	err_order_already_invoiced : INTEGER = 12

	valid_message(a_message_no:INTEGER): BOOLEAN
	do
		Result := err_message.lower <= a_message_no
			and a_message_no <= err_message.upper
	ensure
		Result =( err_message.lower <= a_message_no
			and a_message_no <= err_message.upper)
	end

	product_type_non_empty(type_name: STRING) : BOOLEAN
	do
		if type_name ~ "" or type_name.count = 0 then
			Result:= true
		else
			Result:= false
		end
	end

	product_positive_quantity(product_quantity: INTEGER) : BOOLEAN
	do
		if product_quantity > 0 then
			Result:= true
		else
			Result:= false
		end
	end
end
