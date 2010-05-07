/obj/item/weapon/wireless/PDA
	name = "PDA"
	var/interface = ""

/obj/item/weapon/PDA/attack_self(var/mob/user as mob)
	UpdateWireless()
	if(..())
		return
	usr.machine = src
	winshow(user, interface,1)
	updateuser(user)
/obj/item/weapon/PDA/proc/updateuser(var/mob/user)
	user << output(getbrowser(), "[interface].browser")

/obj/item/weapon/PDA/proc/getbrowser()



/obj/item/weapon/wireless/PDA/Captain
	interface = "obj/item/weapon/wireless/PDA/Captain"