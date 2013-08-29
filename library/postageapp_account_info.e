note
	description: "Summary description for {POSTAGEAPP_ACCOUNT_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSTAGEAPP_ACCOUNT_INFO

inherit
	POSTAGEAPP_ANY
	redefine
		make
	end

create
	make

feature {NONE} -- Initialisation

	make(a_api_key:READABLE_STRING_GENERAL)
		do
			Precursor(a_api_key)
			update
		end

feature -- Access

	update
		do
			print(json_request+"%N")
			send_request
			print(json_result+"%N")
		end

feature {NONE} -- Initialisation

	request_file_name:READABLE_STRING_GENERAL
		once
			Result:=Account_Info_file_name
		end

end
