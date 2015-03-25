note
	description: "Summary description for {INVOICE_SYSTEM_ACCESS}."
	author: "Ursula Sarracini"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	INVOICE_SYSTEM_ACCESS

feature
	m: INVOICE_SYSTEM
		once
			create Result.make
		end

invariant
	m = m
end

