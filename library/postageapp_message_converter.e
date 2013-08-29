note
	description: "Summary description for {POSTAGEAPP_MESSAGE_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSTAGEAPP_MESSAGE_CONVERTER

inherit
	POSTAGEAPP_CONVERTER
	redefine
		to_json
	end

feature -- Conversion

    to_json (a_object: POSTAGEAPP_MESSAGE): JSON_OBJECT
        do
            Result:=Precursor(a_object)
            Result.put (json.value (a_object.uid), Uid_key)
            Result.put (arguments_json_object (a_object), Arguments_key)
        end

feature    {NONE} -- Implementation

	arguments_json_object(a_object: POSTAGEAPP_MESSAGE): JSON_OBJECT
		do
			create Result.make
            Result.put (content_json_object (a_object), Content_key)
            put_argument_in_json(Result,a_object.template,Template_key)
            put_argument_in_json(Result,a_object.recipient_override,Recipient_override_key)
            if not a_object.recipients.is_empty then
            	Result.put (recipient_json_object(a_object.recipients), Recipients_key)
            end
            if not a_object.headers.is_empty then
            	Result.put (list_type_value_to_json(a_object.headers), Headers_key)
            end
			if not a_object.variables.is_empty then
				Result.put (list_type_value_to_json(a_object.variables), Variables_key)
			end
		end

	put_argument_in_json(a_json:JSON_OBJECT;a_value:READABLE_STRING_GENERAL;a_key:JSON_STRING)
		do
			if not a_value.is_empty then
				a_json.put (json.value (a_value), a_key)
			end
		end

	content_json_object(a_object: POSTAGEAPP_MESSAGE): JSON_OBJECT
		do
			create Result.make
			put_argument_in_json(Result, a_object.text_message, Text_message_key)
			put_argument_in_json(Result, a_object.html_message, Html_message_key)
		end

	attachments_json_object(a_attachments:LIST[TUPLE[file_name, content_type, content:READABLE_STRING_GENERAL]]): JSON_OBJECT
		local
			l_attachment_object:JSON_OBJECT
			l_key:JSON_STRING
		do
			create Result.make
			across
				a_attachments as ic_attachment
			loop
				create l_attachment_object.make
				l_attachment_object.put (json.value (ic_attachment.item.content_type), Content_type_key)
				l_attachment_object.put (json.value (ic_attachment.item.content), Content_key)
				create l_key.make_json (ic_attachment.item.file_name.as_string_8)
				Result.put (l_attachment_object, l_key)
			end
		end


	recipient_json_object(a_recipients:LIST[TUPLE[recipient:READABLE_STRING_GENERAL;variables:detachable LIST[TUPLE[name,value:READABLE_STRING_GENERAL]]]]): JSON_OBJECT
		local
			l_key:JSON_STRING
		do
			create Result.make
			across
				a_recipients as ic_recipients
			loop
				create l_key.make_json (ic_recipients.item.recipient.as_string_8)
				if attached ic_recipients.item.variables as la_variables then
					Result.put (list_type_value_to_json(la_variables), l_key)
				else
					Result.put (json.value (Void), l_key)
				end

			end
		end

	list_json_object(a_list:LIST[READABLE_STRING_GENERAL]): JSON_VALUE
    	local
    		l_list_converter:JSON_LIST_CONVERTER
		do
			if attached {LINKED_LIST[READABLE_STRING_GENERAL]} a_list then
            	create {JSON_LINKED_LIST_CONVERTER} l_list_converter.make
            else
            	create {JSON_ARRAYED_LIST_CONVERTER} l_list_converter.make
            end
            if attached l_list_converter.to_json (a_list) as al_json_value then
            	Result:=al_json_value
            else
            	create {JSON_NULL} Result
            	check False end
            end

		end

	list_type_value_to_json(a_list:LIST[TUPLE[type,value:READABLE_STRING_GENERAL]]): JSON_OBJECT
		local
			l_key:JSON_STRING
		do
			create Result.make
			across
				a_list as ic_list
			loop
				create l_key.make_json (ic_list.item.type.as_string_8 )
				Result.put (json.value (ic_list.item.value), l_key)
			end
		end
end
