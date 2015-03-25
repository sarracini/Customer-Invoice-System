note
	description: ""
	author: "Ursula Sarracini"
	date: "$Date$"
	revision: "$Revision$"

class NOTHING
inherit
	NOTHING_INTERFACE
	redefine nothing end
create
	make
feature -- command
	nothing
    	do
			model.nothing
			container.on_change.notify ([Current])
    	end

end
