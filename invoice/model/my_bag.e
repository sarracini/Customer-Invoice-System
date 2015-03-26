note
	description: "ADT for a set with multiplicity."
	author: "Ursula Sarracini"
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG[G -> {HASHABLE, COMPARABLE}]
inherit
	ADT_BAG[G]
	ITERABLE[G]
	DEBUG_OUTPUT

create
	make_empty,
	make_from_tupled_array

convert
	make_from_tupled_array ({attached ARRAY [attached TUPLE[G, INTEGER_32]]})

feature -- attributes
	table:HASH_TABLE[INTEGER, G]

feature -- make features
	make_empty
	do
		create table.make (0)
		table.compare_objects

	end

	make_from_tupled_array(a_array:ARRAY[TUPLE[x: G; y: INTEGER]])
	local
		item_val: INTEGER
	do
		create table.make (a_array.count)
		table.compare_objects
		across a_array as it
		loop
			table.search (it.item.x)
			if table.found /= true then
				table.put (it.item.integer_item(2), it.item.x)
			else
				item_val:= table.found_item
				table.remove(it.item.x)
				table.put(it.item.integer_item(2) + item_val, it.item.x)
			end
		end
	end

feature  -- queries

	is_nonnegative(a_array: ARRAY [TUPLE [x: G; y: INTEGER]]): BOOLEAN
		-- Checks that all items in the bag have non negative value i.e strictly greater or equal to 0
	do
		Result := (across a_array as it all it.item.y >= 0 end)
	end

	bag_equal alias "|=|"(other: like Current): BOOLEAN
		-- Is the current bag like the other bag? i.e are all items the same
	do
		Result := current.table.is_equal (other.table)
	end

	count: INTEGER
		-- Number of items in the bag
	do
		Result := table.count
	end

	domain: ARRAY[G]
		-- Returns the domain of the bag i.e the names of the items present in the bag in sorted order
	local
		sorted:LIST[G]
		arr:ARRAY[G]
		i:INTEGER
	do
		create arr.make_empty
		create {SORTED_TWO_WAY_LIST[G]}sorted.make
		across table.current_keys as z loop sorted.force (z.item) end
		from
			i := 1
		until
			i > sorted.count
		loop
			arr.force (sorted.at (i), i)
			i := i + 1
		end
		arr.compare_objects
		Result:= arr
	end

	occurrences alias "[]" (key: G): INTEGER
		-- Counts the instances of any given item in the bag
	do
		table.search(key)
		if table.found = true then
			Result:= table.found_item
		else
			Result:= 0
		end
	end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
		-- Is the current bag a subset of the other bag? i.e same items and less than occurrences
	do
		Result:= across domain as g all
					found_item(g.item) implies found_item(g.item) and then
					occurrences(g.item) <= other.occurrences(g.item)
				end
	end

	debug_output: READABLE_STRING_GENERAL
	do
		Result := ""
	end

	has_same_items (other: like Current) : BOOLEAN
		-- Returns true if one bag contains the same item types as another bag and false otherwise
	do
		Result:= across other.domain as g all
					found_item(g.item) end
	end

	has_enough_items (other: like Current) : BOOLEAN
		-- Returns true if one bag has less occurrences than or equal to another bag and false otherwise
	do
		Result:= across other.domain as g all
						occurrences(g.item) <= other.occurrences(g.item) end
	end

feature -- commands

	extend  (a_key: G; a_quantity: INTEGER)
		-- Add a single item to a bag
	local
			item_val:INTEGER
	do
		if not found_item(a_key) then
			table.put (a_quantity, a_key)
		else
			item_val:= table.found_item
			table.remove(a_key)
			table.put(a_quantity + item_val, a_key)
		end
	end

	add_all (other: like Current)
		-- Add all items from one bag to anoher bag
	do
		across other.domain as z
		loop
			extend(z.item, other.occurrences(z.item))
		end
	end

	remove  (a_key: G; a_quantity: INTEGER)
		-- Remove a single item from the bag
	do
			if verify_subtraction(a_key, a_quantity) = 0 then
				table.remove (a_key)
			else
				subtract_single(a_key, a_quantity)
			end
	end

	remove_all (other: like Current)
		-- Remove all items found in one bag from another bag
	do
		across other.domain as z
		loop
			subtract_single(z.item, other.occurrences(z.item))
		end
	end

	new_cursor: MY_BAG_ITERATION_CURSOR[G]
		-- A new bag iterator cursor to iterate over our bag
	do
		create Result.make(Current)
		Result.start
	end

feature -- helper queries and commands

	verify_subtraction(a_key:G; a_quantity:INTEGER) : INTEGER
		-- To verify subtraction gives non negative result
	require
		found_an_item: found_item(a_key) = true
		non_negative: a_quantity >= 0
	do
		table.search(a_key)
		if table.found then
			Result:= table.found_item - a_quantity
		end
	end

	found_item(a_key: G) : BOOLEAN
		-- To verify an item exists in the domain
	do
		table.search(a_key)
		if table.found = true then
			Result:= true
		else
			Result:= false
		end
	ensure
		item_found: Result implies has(a_key)
	end

	subtract_single(a_key: G; a_quantity: INTEGER)
		-- To subract a single item from a bag
	require
		can_subtract: verify_subtraction(a_key, a_quantity) >= 0
	local
		item_value:INTEGER
	do
		if found_item(a_key) then
			item_value:= table.found_item - a_quantity
			table.remove(a_key)
			table.put(item_value, a_key)
		end
	ensure
		subtracted: occurrences (a_key) = old occurrences (a_key) - a_quantity
	end
end
