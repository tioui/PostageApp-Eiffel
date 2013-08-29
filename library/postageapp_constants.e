note
	description: "Summary description for {POSTAGEAPP_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSTAGEAPP_CONSTANTS

feature -- Generals

	Version:READABLE_STRING_GENERAL
		once
			Result:="0.1.1"
		end

feature {NONE} -- Implementation

	Postageapp_address:READABLE_STRING_GENERAL
		once
			Result:="api.postageapp.com/v.1.0/"
		end

	Content_type:READABLE_STRING_GENERAL
		once
			Result:="Content-type: application/json"
		end

	User_agent:READABLE_STRING_GENERAL
		local
			l_ise:ISE_RUNTIME
		once
			create l_ise
			Result:="User-Agent: PostageApp-Eiffel "+Version
		end

feature {NONE} -- Any

    api_key_key: JSON_STRING
        once
            create Result.make_json ("api_key")
        end


feature {NONE} -- Initialisation

	Account_Info_file_name:READABLE_STRING_GENERAL
		once
			Result:="get_account_info.json"
		end

feature {NONE} -- Send Message

	Send_message_file_name:READABLE_STRING_GENERAL
		once
			Result:="send_message.json"
		end

	Subject_header_string:READABLE_STRING_GENERAL
		once
			Result:="subject"
		end

	From_header_string:READABLE_STRING_GENERAL
		once
			Result:="from"
		end

	Reply_to_header_string:READABLE_STRING_GENERAL
		once
			Result:="reply-to"
		end

	Cc_header_string:READABLE_STRING_GENERAL
		once
			Result:="CC"
		end


    Uid_key: JSON_STRING
        once
            create Result.make_json ("uid")
        end

    Content_key: JSON_STRING
        once
            create Result.make_json ("content")
        end

    Text_message_key: JSON_STRING
        once
            create Result.make_json ("text/plain")
        end

    Html_message_key: JSON_STRING
        once
            create Result.make_json ("text/html")
        end

    Recipients_key: JSON_STRING
        once
            create Result.make_json ("recipients")
        end

    Arguments_key: JSON_STRING
        once
            create Result.make_json ("arguments")
        end

    Headers_key: JSON_STRING
        once
            create Result.make_json ("headers")
        end

    Variables_key: JSON_STRING
        once
            create Result.make_json ("variables")
        end

    Template_key: JSON_STRING
        once
            create Result.make_json ("template")
        end

    Recipient_override_key: JSON_STRING
        once
            create Result.make_json ("recipient_override")
        end

    Content_type_key: JSON_STRING
        once
            create Result.make_json ("content_type")
        end

end
