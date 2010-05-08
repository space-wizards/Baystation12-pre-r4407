/obj/item/weapon/wireless/PDA
	name = "PDA"
	var/interface = ""
	icon = 'items.dmi'
	icon_state = "PDA"

/obj/item/weapon/wireless/PDA/attack_self(var/mob/user as mob)
	UpdateWireless()
	if(..())
		return
	usr.machine = src
	winshow(user, interface,1)
	updateuser(user)
/obj/item/weapon/wireless/PDA/proc/updateuser(var/mob/user)
	user << output(getbrowser(), "[interface].browser")

/obj/item/weapon/wireless/PDA/proc/getbrowser()

/obj/item/weapon/wireless/PDA/talk_into()


/obj/item/weapon/wireless/PDA/Captain
	interface = "obj/item/weapon/wireless/PDA/Captain"