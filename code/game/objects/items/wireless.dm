/obj/item/weapon/wireless/
	var/obj/machinery/router/router
	var/cnetnum = 0
	var/datum/computernet/computernet = null
	var/uniqueid = null
	var/directwiredCnet = 1
	var/computerID = 0
	var/typeID = null
	var/netID = 0
	var/sniffer = 0
	var/ailabel = ""
	var/list/mob/ai/ais = list()


/obj/item/weapon/wireless/New()
	..()
	computerID = uppertext(num2hex(GetUnitId()))
	typeID = gettypeid(type)

/proc/GetTurf(var/obj/object)
	if(!istype(object,/turf))
		return GetTurf(object.loc)
	return object

/obj/item/weapon/wireless/proc/UpdateWireless()
	var/turf/T = GetTurf(src)
	world << "[T]"
	if(!T.wireless.Find(router))
		if(computernet != null)
			computernet.nodes.Remove(src)
			cnetnum = 0
			computernet = null
	world << "REMOVED"

	if(T.wireless.len >= 1)
		router = T.wireless[1]
		world << router
		cnetnum = router.wirelessnet.number
		computernet = router.wirelessnet
		computernet.nodes.Add(src)
	world << "[router.loc.loc]"

/obj/item/weapon/wireless/proc/transmitmessage(message as text)
	if (!message || !computernet) //If not connected, busted, or powerless then don't bother sending
		return 0
	computernet.send(message, src) //Moved this into the computernet's send proc.
	return 1

/obj/item/weapon/wireless/proc/identinfo() //Meant to be overridden by machines
	return ""

/obj/item/weapon/wireless/proc/receivemessage(var/message, var/obj/srcmachine)

	for (var/mob/ai/AI in ais)
		AI.AIreceivemessage(message,srcmachine)

	var/list/commands = dd_text2list(uppertext(stripnetworkmessage(message)), " ", null)
	if(commands.len < 1)
		return 1
	switch (commands[1])
		if ("IDENT")
			transmitmessage(createmessagetomachine("REPORT UNIT [src.typeID] [replace(name, " ", "")] [src.identinfo()]", srcmachine))
			return 1
		if ("PING")
			if(commands.len == 1)
				transmitmessage(createmessagetomachine("PING REPLY", srcmachine))
			return 1
	return 0


obj/item/weapon/wireless/proc/createmessagetomachine(var/message as text, var/obj/destmachine)
	if (!destmachine:computernet || !src.computernet) //Both have to be connected to a network to attempt this
		return
	var/nid = "000"
	if (src.computernet != destmachine:computernet)
		nid = destmachine:computernet.id
	return uppertext("[nid] [destmachine:computerID] [message]")

/client/verb/checkwifi(var/turf/t as turf)
	for(var/obj/machinery/router/a in t.wireless)
		src << a