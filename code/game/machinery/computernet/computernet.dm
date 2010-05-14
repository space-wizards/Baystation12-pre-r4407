//IT WORKS!  IT ALL JUST WORKS!

/obj/machinery/proc/updateicon()
	return

/obj/machinery/proc/identinfo() //Meant to be overridden by machines
	return ""

/datum/computernet
	var/list/obj/computercable/cables = list()
	var/list/nodes = list()
	var/number = 0
	var/id = null
	var/list/obj/machinery/router/routers = list()
	var/list/obj/machinery/sniffers = list()
	var/disrupted = 0 //1 if a Packet Killer is attached
	var/global/list/usednetids = list()

/obj/machinery/router/identinfo()
	return "SERVICING [src.connectednets.len] AT [replace(loc.loc.name," ","")]"

/datum/computernet/New()
	..()
	id = uppertext(num2hex(GetNetId()))

/obj/machinery/proc/getcommandlist(var/message as text)
	return dd_text2list(uppertext(stripnetworkmessage(message)), " ", null)

/obj/machinery/New()
	..()
	computerID = uppertext(num2hex(GetUnitId()))
	typeID = gettypeid(type)

proc/GetUnitId()
	var/I = 0
	while (!I || (I in usedids))
		I = rand(4096, 65535) //1000 - FFFF
	usedids += I
	return I

/datum/computernet/proc/GetNetId()
	var/I = 0
	while (!I && !(I in usednetids))
		I = rand(256, 4095) //100 - FFF
	usednetids += I
	return I


/datum/computernet/proc/propagate(packet, messagelist, sendingunit)

	world << messagelist

	if (disrupted)
		return 0

	for (var/obj/machinery/M in sniffers)
		M:receivemessage(packet, sendingunit) //Sniffers get it too (they might get it twice, if the packet was directed at them)


	if(messagelist[1] != src.id && messagelist[1] != "000") return

	if(messagelist[2] != "MULTI") //If so, is this a multicast or single-reciever packet

		if(nodes[messagelist[2]]) //Single-reciever, can we find it on the network?
			var/obj/M = nodes[messagelist[2]]
			M:receivemessage(packet, sendingunit)

	else //Multicast

		if (messagelist[3] == "***") //TO EVERYONE
			for (var/obj/M in nodes)
				M:receivemessage(packet, sendingunit)

		else //To everyone of TypeId ___

			messagelist[3] = uppertext(messagelist[3])
			for (var/obj/M in nodes)
				if (messagelist[3] == M:typeID)
					M:receivemessage(packet, sendingunit)
	return 1

/datum/computernet/proc/send(var/packet as text, var/obj/sendingunit)
	world << "[packet] being send"
	//Ok, lets break down the message into its key components
	var/list/messagelist = dd_text2list(packet," ",null)

	messagelist[1] = uppertext(messagelist[1]) //And filter the components
	messagelist[2] = uppertext(messagelist[2])

	if (messagelist[1] == "000" || messagelist[1] == id) //Check if it's the local net code, or if the netid is the loopback code
		world << "GOING"
		src.propagate(packet, messagelist, sendingunit)

	else //No, it's on another net
		if (!(id in routingtable.sourcenets) || !(messagelist[1] in routingtable.sourcenets[src.id]) || !routingtable.sourcenets[src.id][messagelist[1]])
			world << "CANT GET THERE"
			return //But it can't get there from here, or better yet either this net or the dest net aren't in the routing table
				   //If it's one of the latter, hopefully it was caused by a human typoing an id

		var/list/datum/computernet/nets = routingtable.sourcenets[src.id][messagelist[1]]

		for(var/datum/computernet/net in nets)
			if (!net.propagate(packet, messagelist, sendingunit))
				return

/obj/machinery/proc/receivemessage(var/message, var/obj/srcmachine)
	if (stat & BROKEN) return 1 //Broken things never respond, but they may be able to recieve packets when off
							  	//(Networks have a small amount of implied power)
	for (var/mob/ai/AI in ais)
		AI.AIreceivemessage(message,srcmachine)

	var/list/commands = dd_text2list(uppertext(stripnetworkmessage(message)), " ", null)
	if(commands.len < 1)
		return 1
	switch (commands[1])
		if ("POWER")
			switch (commands[2])
				if ("ON")
					stat &= ~NOPOWER
				if ("OFF")
					stat |= NOPOWER
			updateicon()
			return 1
		if ("IDENT")
			transmitmessage(createmessagetomachine("REPORT UNIT [src.typeID] [replace(name, " ", "")] [src.identinfo()]", srcmachine))
			return 1
		if ("PING")
			if(commands.len == 1)
				transmitmessage(createmessagetomachine("PING REPLY", srcmachine))
			return 1
		if("CONTROL")
			attack_ai(usr)
			return 1
	return 0


/obj/machinery/proc/transmitmessage(message as text)
	if (!message || !computernet || (stat & (NOPOWER|BROKEN))) //If not connected, busted, or powerless then don't bother sending
		return 0
	computernet.send(message, src) //Moved this into the computernet's send proc.
	return 1

proc/gettypeid(var/T)
	if (usedtypes["[T]"])
		return usedtypes["[T]"]
	else
		usedtypes["[T]"] = num2hex(rand(1, 16777215), 6)
		return usedtypes["[T]"]

obj/machinery/proc/createmulticast(var/netid as text, var/typeid as text, var/message as text)
	if (!src.computernet)
		return
	return uppertext("[netid] MULTI [typeid] [message]")


obj/machinery/proc/createmessagetomachine(var/message as text, var/obj/destmachine)
	if (!destmachine:computernet || !src.computernet) //Both have to be connected to a network to attempt this
		return
	var/nid = "000"
	if (src.computernet != destmachine:computernet)
		nid = destmachine:computernet.id
	return uppertext("[nid] [destmachine:computerID] [message]")


/proc/stripnetworkmessage(message as text)
	var/list/messagelist = dd_text2list(message," ",null)
	if(uppertext(messagelist[2]) == "MULTI")
		return copytext(message,15 + (messagelist[3] == "***" ? 0 : 3),0) //"123 MULTI 456789 COMMAND" => "COMMAND"
	else																 //"123 MULTI *** COMMAND" => "COMMAND"
		return copytext(message,10) //"123 4567 COMMAND" => "COMMAND"

/proc/checkcommand(var/list/message,var/index,var/word)
	if(message.len >= index)
		if(message[index] == word)
			return 1
	return 0