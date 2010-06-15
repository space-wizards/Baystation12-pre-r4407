/obj/machinery/sniffer/attack_hand(var/mob/user as mob)
	if(..())
		return
	usr.machine = src
	winshow(user, "obj/machinery/sniffer")
	updateuser(user)

/obj/machinery/sniffer/proc/updateuser(var/mob/user)
	user << output(browser, "obj/machinery/sniffer.browser")

/obj/machinery/sniffer/receivemessage(var/message, var/obj/sendingunit)
	browser = "[message] from [sendingunit:computernet.id] [sendingunit:computerID]<br>[browser]"
	updateUsrDialog()

/obj/machinery/sniffer/UIinput(message)
	switch(message)
		if("send")
			var/msg = winget(usr, "obj/machinery/sniffer.messageSend", "text")
			winset(usr, "obj/machinery/sniffer.messageSend", "text=\"\"")
			transmitmessage(msg)
		if("clear")
			usr << output("", "obj/machinery/sniffer.browser")
			browser = ""

/obj/machinery/computer/networksniffer
	var/browser

/obj/machinery/computer/networksniffer/attack_hand(var/mob/user as mob)
	if(..())
		return
	usr.machine = src
	winshow(user, "obj/machinery/sniffer")
	updateuser(user)

/obj/machinery/computer/networksniffer/proc/updateuser(var/mob/user)
	user << output(browser, "obj/machinery/sniffer.browser")

/obj/machinery/computer/networksniffer/receivemessage(var/message, var/obj/sendingunit)
	browser = "[message] from [sendingunit:computernet.id] [sendingunit:computerID]<br>[browser]"
	updateUsrDialog()

/obj/machinery/computer/networksniffer/UIinput(message)
	switch(message)
		if("send")
			var/msg = winget(usr, "obj/machinery/sniffer.messageSend", "text")
			winset(usr, "obj/machinery/sniffer.messageSend", "text=\"\"")
			transmitmessage(msg)
		if("clear")
			usr << output("", "obj/machinery/sniffer.browser")
			browser = ""