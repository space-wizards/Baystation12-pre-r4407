/obj/item/weapon/bulb/New()
	..()
	src.life = rand(1700, 10000) //Nanotransern's bulb suppliers have no quality control, who knows how long one'll last.
								 //The values are approximately in seconds

/obj/item/weapon/bulb/proc/use()
	if (src.life)
		src.life--
		desc = extext()

/obj/item/weapon/bulb/proc/extext()
	if (!life)
		return "The bulb has burned out"
	else if (life <= 2000)
		return "The bulb appears to be worn, but working"
	else
		return "The bulb appears to be in good condition"

/obj/machinery/light/New()
	..()
	area = loc.loc
	bulb = new basetype()
	bulb.use()
	on = 0
	sd_SetLuminosity(0)

/obj/machinery/light/examine(mob/user as mob)
	user << "This is a [bulbtype] light fixture"
	if (stat & BROKEN)
		user << "The bulb has been shattered"
	else if (bulb)
		user << bulb.desc
		if (bulb.life && ((stat & NOPOWER) || !on))
			user << "The light is off"
	else
		user << "There is no bulb installed"

/obj/machinery/light/attack_ai(mob/user as mob)
	if (stat & (NOPOWER|BROKEN) || !bulb)
		return
	if (on)
		turnoff()
	else
		turnon()

/obj/machinery/light/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/light/proc/bright()
	if (!bulb.life) return 0
	if (bulb.life < 2000) return min(baselum, bulb.bright) / 2
	return min(baselum, bulb.bright)

/obj/machinery/light/attack_hand(mob/user as mob)
	if (!bulb)
		user << "There is no bulb to remove"
	else
		if (stat & BROKEN)
			user << "You remove and discard the broken bulb pieces"
			oviewers(user, null) << text("[] cleans the [] shards from the [].", user, bulb, src)
			stat &= ~BROKEN
		else
			user << "You take out the bulb"
			oviewers(user, null) << text("\red [] has removed the [] from the [].", user, bulb, src)
			sd_SetLuminosity(0)
			on = 0
			if (user.hand )
				user.l_hand = bulb
			else
				user.r_hand = bulb
			bulb.loc = usr
			bulb.layer = ITEM_HUD_LAYER
			bulb.add_fingerprint(user)
		icon_state = "[gset]-n"
		bulb = null

/obj/machinery/light/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/bulb))
		var/obj/item/weapon/bulb/B = W
		if (src.bulb)
			user << "\red There is already a bulb in the [src.name]"
		else if (B.bulbtype != src.bulbtype)
			user << "\red This is the wrong bulb type!  You have a [B.bulbtype], the fixture takes a [src.bulbtype]!"
		else
			oviewers(user, null) << text("[] has fitted the [] in the []", user, W, src)
			user << "You place the [W.name] in the [src.name]"
			user.drop_item()
			W.loc = src
			bulb = W
	else
		oviewers(user, null) << text("\red [] has smashed the []!", user, src)
		user << "\red You smash the [src.name]'s bulb with your [W.name]"
		stat |= BROKEN
		sd_SetLuminosity(0)
		on = 0
		icon_state = "[gset]-b"

/obj/machinery/light/proc/updateicon()
	icon_state = "[gset][area.power_light && area.lightswitch && bulb.life ? (bulb.life > 2000 ? "" : "-h") : "-p"]"

/obj/machinery/light/process()
	if (!ticker)
		if (!(stat & BROKEN) && bulb && bulb.life)
			turnon()
		else
			turnoff()
		return

	if ((stat & (NOPOWER|BROKEN)) || (!bulb))
		return

	if ((powered(LIGHT) && area.lightswitch && bulb.life))
		turnon()
	else
		turnoff()

	if (on)
		area.use_power(15 * max(baselum, bulb.bright), LIGHT)

	bulb.use()

/obj/machinery/light/power_change()
	return

/obj/machinery/light/proc/turnon()
	if (!on)
		on = 1
		spawn(instant ? 0 : rand(3,13))
			if (on)
				updateicon()
				sd_SetLuminosity(bright() / 2)
				sleep(instant ? 0 : 9)
				if (on)
					updateicon()
					sd_SetLuminosity(bright())
	else if (src.luminosity != bright())
		sd_SetLuminosity(bright())
		updateicon()

/obj/machinery/light/proc/turnoff()
	if (on)
		on = 0
		spawn(instant ? 0 : rand(1,2))
			if (!on)
				updateicon()
				sd_SetLuminosity(0)