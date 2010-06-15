
/obj/machinery/turretid
	name = "Turret deactivation control"
	icon = 'items.dmi'
	icon_state = "motion3"
	anchored = 1
	density = 0
	var/enabled = 1
	var/lethal = 0
	var/locked = 1
	req_access = list(access_ai)

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN) return
	if (istype(user, /mob/ai))
		return src.attack_hand(user)
	else // trying to unlock the interface
		if (src.allowed(usr))
			locked = !locked
			user << "You [ locked ? "lock" : "unlock"] the panel."
			if (locked)
				if (user.machine==src)
					user.machine = null
					user << browse(null, "window=turretid")
			else
				if (user.machine==src)
					src.attack_hand(usr)
		else
			user << "\red Access denied."

/obj/machinery/turretid/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/ai))
			user << text("Too far away.")
			user.machine = null
			user << browse(null, "window=turretid")
			return

	user.machine = src
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		user << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	var/t = "<TT><B>Turret Control Panel</B> ([area.name])<HR>"

	if(src.locked && (!istype(user, /mob/ai)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Turrets [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br>\n", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
		t += text("Currently set for [] - <A href='?src=\ref[];toggleLethal=1'>Change to []?</a><br>\n", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")

	user << browse(t, "window=turretid")

/obj/machinery/turretid/Topic(href, href_list)
	..()
	if (src.locked)
		if (!istype(usr, /mob/ai))
			usr << "Control panel is locked!"
			return
	if (href_list["toggleOn"])
		src.enabled = !src.enabled
		src.updateTurrets()
	else if (href_list["toggleLethal"])
		src.lethal = !src.lethal
		src.updateTurrets()
	src.attack_hand(usr)

/obj/machinery/turretid/proc/updateTurrets()
	if (src.enabled)
		if (src.lethal)
			icon_state = "motion1"
		else
			icon_state = "motion3"
	else
		icon_state = "motion0"

	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		world << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	for(var/area/B in area.superarea.areas)
		for (var/obj/machinery/turret/aTurret in B)
			aTurret.setState(enabled, lethal)

/obj/machinery/turretid/receivemessage(message,sender)
	if(..())
		return
	var/command = uppertext(stripnetworkmessage(message))
	var/listofcommand = dd_text2list(command," ",null)
	if(check_password(listofcommand[1]))
		if(checkcommand(listofcommand,2,"TURRETS"))
			if(checkcommand(listofcommand,3,"OFF"))
				src.enabled = 0
				src.lethal = 0
			else if(checkcommand(listofcommand,3,"STUN"))
				src.enabled = 1
				src.lethal = 0
			else if(checkcommand(listofcommand,3,"LETHAL"))
				src.enabled = 1
				src.lethal = 1
			src.updateTurrets()
			src.updateUsrDialog()
		else if(checkcommand(listofcommand,3,"INTERFACE"))
			if(checkcommand(listofcommand,2,"LOCK"))
				src.locked = 1
			else if(checkcommand(listofcommand,2,"UNLOCK"))
				src.locked = 0
			src.updateUsrDialog()

/obj/machinery/turretid/identinfo()
	if(src.enabled)
		if(src.lethal)
			return "TURRETS LETHAL"
		else
			return "TURRETS STUN"
	return "TURRETS OFF"
