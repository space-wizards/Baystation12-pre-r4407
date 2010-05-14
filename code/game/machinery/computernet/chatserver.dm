/obj/machinery/chatserver
	name = "Message server"
	var/servername = "DEFAULT"
	var/list/networkaddresses = list()
	icon = 'netobjs.dmi'
	icon_state = "mailserv"

//This is a standin for a proper networking thing
//The PDAs should report their network address to receive updates

/obj/machinery/chatserver/receivemessage(message as text, var/obj/srcmachine)
	if (..())
		return
//	world << "ROUTER REC [message]"
	var/list/commands = getcommandlist(message)
	if(commands.len < 2)
		return
	world << "CHAT REC [message]"
	if(commands[1] == "MESSAGE")
		for(var/address in networkaddresses)
			transmitmessage(address + " [message]")


	if(commands[1] == "UPDATE")
		networkaddresses["[commands[2]]"] = commands[2] + " " + commands[3]