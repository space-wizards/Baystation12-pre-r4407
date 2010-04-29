/obj/machinery/sniffer/attack_hand(var/mob/user as mob)
	if(..())
		return
	usr.machine = src
	winshow(user, "obj/machinery/sniffer",1)
	updateuser(user)

/obj/machinery/sniffer/proc/updateuser(var/mob/user)
	user << output(browser, "obj/machinery/sniffer.browser")

/obj/machinery/sniffer/receivemessage(message)
	browser = "[message]<br>[browser]"
	updateUsrDialog()

/obj/machinery/sniffer/UIinput(message)
	var/list/msg = dd_text2list(message," ",null)
	if(msg.len >= 2)
		if(msg[1] == "transmit")
			transmitmessage(message)
			return 1



/obj/machinery/computer/networksniffer
	var/browser

/obj/machinery/computer/networksniffer/attack_hand(var/mob/user as mob)
	if(..())
		return
	usr.machine = src
	winshow(user, "obj/machinery/sniffer",1)
	updateuser(user)

/obj/machinery/computer/networksniffer/proc/updateuser(var/mob/user)
	user << output(browser, "obj/machinery/sniffer.browser")

/obj/machinery/computer/networksniffer/receivemessage(message)
	browser = "[message]<br>[browser]"
	updateUsrDialog()

/obj/machinery/computer/networksniffer/UIinput(message)
	var/list/msg = dd_text2list(message," ",null)
	if(msg.len >= 2)
		if(msg[1] == "transmit")
			transmitmessage(message)
			return 1
	updateUsrDialog()