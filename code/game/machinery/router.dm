/obj/machinery/router/attack_ai(mob/ai/user as mob)
	if(stat & (NOPOWER|BROKEN))
		user << "\red The router is not responding"
		return

	user.machine = src
	if (istype(user, /mob/human) || istype(user, /mob/ai))
		var/dat = {"<HTML><HEAD></HEAD><BODY><TT>[loc.loc.name] Network Router<BR>
Primary operating system online<HR>
Servicing [connectednets.len + disconnectednets.len] Networks<BR>
[netlist()]
</TT></BODY></HTML>"}
		user << browse(dat, "window=router")
	return

/obj/machinery/router/receivemessage(message as text, obj/machinery/srcmachine)
	if (..())
		return
//	world << "ROUTER REC [message]"
	var/list/commands = getcommandlist(message)
	if(commands.len < 3)
		return
	if (!check_password(commands[1]))
	//	world << "ROUTER BAD PASS"
		return
	var/datum/computernet/cnet = null
	for (var/datum/computernet/net in computernets)
		if(net.id == commands[3])
			cnet = net
			break
	if (commands[2] == "DISCON")
		connectednets -= cnet
		disconnectednets += cnet
		BuildRoutingTable()
	else if (commands[2] == "RECON")
		connectednets += cnet
		disconnectednets -= cnet
		BuildRoutingTable()

/obj/machinery/router/Topic(href, href_list)
	if (stat & (BROKEN|NOPOWER))
		return
	if (istype(usr, /mob/ai))
		var/mob/ai/aiusr = usr
		usr.machine = src
		var/datum/computernet/cnet
		var/pw = get_password()
		if (href_list["toggle"])
			for (var/datum/computernet/net in computernets)
				if(net.id == href_list["toggle"])
					cnet = net
					break
			if(cnet in connectednets)
				aiusr.sendcommand("[pw] DISCON [href_list["toggle"]]", src)
			else if (cnet in disconnectednets)
				aiusr.sendcommand("[pw] RECON [href_list["toggle"]]", src)
			src.updateUsrDialog()

/obj/machinery/router/proc/netlist()
	var/dat = "Active Networks:<BR>"
	for(var/datum/computernet/net in connectednets)
		dat += "Network [net.id] \[<A href='?src=\ref[src];toggle=[net.id]'>Disconnect</A>]<BR>"
	dat += "Inactive Networks: <BR>"
	for(var/datum/computernet/net in disconnectednets)
		dat += "Network [net.id] \[<A href='?src=\ref[src];toggle=[net.id]'>Connect</A>]<BR>"
	return dat

/obj/machinery/router/New()
	..()
	for(var/turf/T in range(100,src))
		if(!T.wireless.Find(src))
			T.wireless.Add(src)

/obj/machinery/router/Del()
	..()
	for(var/turf/T in range(100,src))
		if(T.wireless.Find(src))
			T.wireless.Remove(src)
/obj/machinery/router/verb/ResetWifi()
	var/wificount
	for(var/turf/T in range(100,src))
		if(!T.wireless.Find(src))
			T.wireless.Add(src)
		wificount += 1

	world << wificount