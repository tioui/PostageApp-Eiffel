note
	description : "Eiffel_PostageApp application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_message:POSTAGEAPP_MESSAGE
			l_variables_recipients:ARRAYED_LIST[TUPLE[name,value:READABLE_STRING_GENERAL]]
		do
			create l_message.make (Api_key)
			l_message.text_message:="Le message"
			l_message.html_message:="<p>Le message</p>"
			l_message.add_recipient (Email1)
			create l_variables_recipients.make_from_array (<<["Var1","Value1"],["Var2","Value2"]>>)
			l_message.recipients.extend ([Email2,l_variables_recipients])
			l_message.subject:="Sujet!"
			l_message.from_value:=Email3
			l_message.send
		end

	Email1:READABLE_STRING_GENERAL
		once
			Result:="first@email.com"
		end

	Email2:READABLE_STRING_GENERAL
		once
			Result:="second@email.com"
		end

	Email3:READABLE_STRING_GENERAL
		once
			Result:="third@email.com"
		end

	Api_key:READABLE_STRING_GENERAL
		once
			Result:="Your Key"
		end

end
