
obj/machinery/TestCmdr/verb/rebuildnets()
	set src in oview(3)
	set name = "Rebuild computer nets"
	makecomputernets()
	world << "Nets rebuilt"

obj/machinery/verb/GETNETINFO()
	set name = "Get Network connection info"
	set src in world
	if (!computernet)
		usr << "[src] is not connected to a network"
		return
	usr << "Network information for [name]: [computernet.id] [computerID]"

/obj/machinery/TestCmdr/verb/TESTMULTI()
	set src in world
	src.transmitmessage(createmulticast("000", "***", "PING"))

/obj/machinery/TestCmdr/verb/SEND(message as text)
	set src in world
	src.transmitmessage(message)

/obj/machinery/verb/GetPasswords()
	set src in view(5)
	if(!req_access)
		usr << "No passwords"
		return
	for (var/M in src.req_access)
		usr << get_access_desc(M) + ": " + accesspasswords["[M]"]


obj/machinery/TestCmdr/receivemessage(message as text, var/obj/machinery/srcmachine)
	if (stat & BROKEN) return
	var/list/rawcommands = dd_text2list(uppertext(message), " ", null)
	if(rawcommands[1] != src.computernet.id && rawcommands[1] != "000")
		return
	if(rawcommands[2] != computerID)
		return
	var/list/commands = dd_text2list(uppertext(stripnetworkmessage(message)), " ", null)
	switch (commands[1])
		if ("PING")
			if(commands.len == 1)
				transmitmessage(createmessagetomachine("PING REPLY", srcmachine))
			return
	world << "TESTRC << [rawcommands]"
	return