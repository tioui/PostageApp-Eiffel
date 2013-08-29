note
	description: "Summary description for {POSTAGEAPP_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSTAGEAPP_CONVERTER

inherit
	SHARED_EJSON
	POSTAGEAPP_CONSTANTS

feature -- Conversion

	to_json(a_object: POSTAGEAPP_ANY): JSON_OBJECT
		do
			create Result.make
            Result.put (json.value (a_object.api_key), Api_key_key)
		end

end
