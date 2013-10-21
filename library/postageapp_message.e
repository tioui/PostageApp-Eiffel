note
	description: "Summary description for {POSTAGEAPP_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSTAGEAPP_MESSAGE

inherit
	POSTAGEAPP_ANY
	rename
		make as make_any
	redefine
		json_request
	end

create
	make

feature {NONE} -- Initialization

	make(a_api_key:READABLE_STRING_GENERAL)
			-- Initialization for `Current'.
		do
			make_any(a_api_key)
			create {ARRAYED_LIST[TUPLE[READABLE_STRING_GENERAL,detachable LIST[TUPLE[name,value:READABLE_STRING_GENERAL]]]]} recipients.make(1)
			create {ARRAYED_LIST[TUPLE[type,value:READABLE_STRING_GENERAL]]} headers.make(2)
			create {ARRAYED_LIST[TUPLE[name,value:READABLE_STRING_GENERAL]]}variables.make (0)
			create {ARRAYED_LIST[TUPLE[file_name, content_type, base64_encoded_content:READABLE_STRING_GENERAL]]} attachments.make (0)
			set_html_message ("")
			set_text_message ("")
			set_template ("")
			set_recipient_override ("")
			change_uid
		end

feature -- Access

	uid:READABLE_STRING_GENERAL assign set_uid

	set_uid(a_uid:READABLE_STRING_GENERAL)
		do
			uid:=a_uid
		end

	change_uid
		local
			l_uuid_generator:UUID_GENERATOR
		do
			create l_uuid_generator
			uid:=l_uuid_generator.generate_uuid.string
		end

	text_message:READABLE_STRING_GENERAL assign set_text_message

	set_text_message(a_text_message:READABLE_STRING_GENERAL)
		do
			text_message:=a_text_message
		end

	html_message:READABLE_STRING_GENERAL assign set_html_message

	set_html_message(a_html_message:READABLE_STRING_GENERAL)
		do
			html_message:=a_html_message
		end

	recipients:LIST[TUPLE[recipient:READABLE_STRING_GENERAL;variables:detachable LIST[TUPLE[name,value:READABLE_STRING_GENERAL]]]]

	add_recipient(a_recipient:READABLE_STRING_GENERAL)
		do
			recipients.extend ([a_recipient,Void])
		end



	headers:LIST[TUPLE[type,value:READABLE_STRING_GENERAL]]

	subject:READABLE_STRING_GENERAL assign set_subject
		do
			Result:=get_in_headers(Subject_header_string)
		end

	set_subject(a_subject:READABLE_STRING_GENERAL)
		do
			set_in_headers(Subject_header_string,a_subject)
		ensure
			Subject_Is_Set: subject.same_string (a_subject)
			Headers_Valid:headers.count = old headers.count or headers.count = old headers.count+1
		end

	from_value:READABLE_STRING_GENERAL assign set_from_value
		do
			Result:=get_in_headers(From_header_string)
		end

	set_from_value(a_from:READABLE_STRING_GENERAL)
		do
			set_in_headers(From_header_string,a_from)
		ensure
			From_Is_Set: from_value.same_string (a_from)
			Headers_Valid:headers.count = old headers.count or headers.count = old headers.count+1
		end

	reply_to:READABLE_STRING_GENERAL assign set_reply_to
		do
			Result:=get_in_headers(Reply_to_header_string)
		end

	set_reply_to(a_reply_to:READABLE_STRING_GENERAL)
		do
			set_in_headers(Reply_to_header_string,a_reply_to)
		ensure
			Reply_To_Is_Set: reply_to.same_string (a_reply_to)
			Headers_Valid:headers.count = old headers.count or headers.count = old headers.count+1
		end

	cc:READABLE_STRING_GENERAL assign set_cc
		do
			Result:=get_in_headers(Cc_header_string)
		end

	set_cc(a_cc:READABLE_STRING_GENERAL)
		do
			set_in_headers(Cc_header_string,a_cc)
		ensure
			Cc_Is_Set: cc.same_string (a_cc)
			Headers_Valid:headers.count = old headers.count or headers.count = old headers.count+1
		end

	template:READABLE_STRING_GENERAL assign set_template

	set_template(a_template: like template)
		do
			template:=a_template
		end

	variables:LIST[TUPLE[name,value:READABLE_STRING_GENERAL]]

	recipient_override: READABLE_STRING_GENERAL assign set_recipient_override

	set_recipient_override(a_recipient_override: like recipient_override)
		do
			recipient_override:=a_recipient_override
		end

	attachments:LIST[TUPLE[file_name, content_type, base64_encoded_content:READABLE_STRING_GENERAL]]

	attach_file(a_file_name:READABLE_STRING_GENERAL)
		require
			Attach_File_Is_Valid: 	(attached {FILE} (create {RAW_FILE}.make_with_name (a_file_name)) as la_file) implies
									la_file.exists and then la_file.is_readable
		do
			attach_file_with_content_type(a_file_name,find_content_type(a_file_name))
		end

	attach_file_with_content_type(a_file_name,a_content_type:READABLE_STRING_GENERAL)
		require
			Attach_File_Is_Valid: 	(attached {FILE} (create {RAW_FILE}.make_with_name (a_file_name)) as la_file) implies
									la_file.exists and then la_file.is_readable
		local
			l_file:FILE
			l_data:ARRAYED_LIST[CHARACTER_8]
		do
			create {RAW_FILE} l_file.make_with_name (a_file_name)
			create l_data.make (l_file.count)
			l_data.append (l_file)
			attach_from_memory_with_content_type(a_file_name, a_content_type, l_data.area)
		end

	attach_from_memory(a_file_name:READABLE_STRING_GENERAL;a_data:SPECIAL[CHARACTER_8])
		do
			attach_from_memory_with_content_type(a_file_name, find_content_type(a_file_name),a_data)
		end

	attach_from_memory_with_content_type(a_file_name,a_content_type:READABLE_STRING_GENERAL;a_data:SPECIAL[CHARACTER_8])
		local
			l_data_string:STRING_8
			l_encoder:BASE64
		do
			create l_data_string.make (a_data.count)
			l_data_string.area.copy_data (a_data , 0, 0, a_data.count)
			create l_encoder
			attachments.extend ([a_file_name, a_content_type, l_encoder.encoded_string (l_data_string)])
		end

	attach_from_string(a_file_name,a_data:READABLE_STRING_GENERAL)
		do
			attach_from_string_with_content_type(a_file_name,find_content_type(a_file_name),a_data)
		end



	attach_from_string_with_content_type(a_file_name,a_content_type,a_data:READABLE_STRING_GENERAL)
		do
			attach_from_memory_with_content_type(a_file_name,a_content_type,a_data.to_string_8.area)
		end

	send
		do
			print(json_request+"%N")
			send_request
			print(json_result+"%N")
		end

	json_request:READABLE_STRING_GENERAL
		local
			l_converter:POSTAGEAPP_MESSAGE_CONVERTER
			l_json_object:JSON_OBJECT
		do
			create l_converter
			l_json_object:=l_converter.to_json (Current)
			Result:=l_json_object.representation

		end


feature {NONE} -- Implementation

	request_file_name:READABLE_STRING_GENERAL
		once
			Result:=Send_message_file_name
		end

	get_in_headers(a_type:READABLE_STRING_GENERAL):READABLE_STRING_GENERAL
		do
			Result:=""
			across
				headers as ic_headers
			loop
				if ic_headers.item.type.same_string(a_type) then
					Result:=ic_headers.item.value
				end
			end
		end

	set_in_headers(a_type,a_value:READABLE_STRING_GENERAL)
		local
			l_is_found:BOOLEAN
		do
			from
				headers.start
				l_is_found:=False
			until
				headers.exhausted or
				l_is_found
			loop
				if headers.item.type.same_string (a_type) then
					headers.item.value:=a_value
					l_is_found:=True
				end
				headers.forth
			end
			if not l_is_found then
				headers.extend ([a_type,a_value])
			end
		end

	find_content_type(a_file_name:READABLE_STRING_GENERAL):READABLE_STRING_GENERAL
		local
			l_mime_detector:HTTP_FILE_EXTENSION_MIME_MAPPING
			l_extension:detachable READABLE_STRING_GENERAL
			l_extension_position, l_temp_position:INTEGER
			l_fin:BOOLEAN
		do
			from
				l_extension_position:=1
				l_fin:=False
			until
				not l_fin
			loop
				l_temp_position:= a_file_name.index_of ('.', l_extension_position)
				if l_temp_position=0 then
					l_fin:=True
				else
					l_extension_position:=l_temp_position+1
				end
			end
			create l_mime_detector.make_default
			l_extension:=l_mime_detector.mime_type (a_file_name.substring (l_extension_position, a_file_name.count))
			if attached l_extension as la_extension then
				Result:=la_extension
			else
				Result:="application/octet-stream"
			end
		end



end
