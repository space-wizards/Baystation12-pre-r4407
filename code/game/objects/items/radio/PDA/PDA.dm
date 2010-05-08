/obj/item/weapon/wireless/PDA
	name = "PDA"
	var/interface = ""
	icon = 'items.dmi'
	icon_state = "PDA"
	var/obj/machinery/chatserver/chatserver

	var/chatconnected

	var/panel = 0

/obj/item/weapon/wireless/PDA/New()
	..()
	for(var/obj/machinery/chatserver/a in world)
		if(a.servername == "Primary")
			chatserver = a

/obj/item/weapon/wireless/PDA/attack_self(var/mob/user as mob)
	UpdateWireless()
	if(..())
		return
	user.weapon = src
	winshow(user, interface,1)
	updateuser(user)
/obj/item/weapon/wireless/PDA/proc/updateuser(var/mob/user)
	user << output(GetHomepage(), "PDAbrowser.browser")

/obj/item/weapon/wireless/PDA/proc/getbrowser()
	var/dat
	if(panel == 0)
		dat += "Nano-transen PDA interface<p></p><center>1.3 SOFTWARE</center><p></p>"
		dat += "Communications"

//	if(chatserver != null)

/obj/item/weapon/wireless/PDA/talk_into(message as text)
	UpdateWireless()
	world << transmitmessage(createmessagetomachine("MESSAGE [message]",chatserver))


/obj/item/weapon/wireless/PDA/Captain
	interface = "obj/item/weapon/wireless/PDA/Standard"