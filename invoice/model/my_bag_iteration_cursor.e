note
	description: "Summary description for {MY_BAG_ITERATION_CURSOR}."
	author: “Ursula Sarracini“
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG_ITERATION_CURSOR[G -> {HASHABLE, COMPARABLE}]
inherit
	ITERATION_CURSOR[G]
create
	make

feature
	make(bag : MY_BAG[G])
	do
		create array.make_from_array(bag.domain)
	end

feature -- queries and commands
	array: ARRAY[G]
	index: INTEGER

	item: G
	do
		Result := array[index]
	end

	start
	do
		index := 1
	end

	after: BOOLEAN
	do
		Result := index > array.count or array.count = 0
	end

	forth
	do
		index := index + 1
	end

end
