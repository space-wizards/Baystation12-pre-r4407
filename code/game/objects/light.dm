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
			icon_state = "[gset]-n"
			bulb = null
		else if(src.open)
			user << "You take out the bulb"
			oviewers(user, null) << text("\red [] has removed the [] from the [].", user, bulb, src)
			sd_SetLuminosity(0)
			on = 0
			if (user.hand )
				user.l_hand = bulb
			else
				user.r_hand = bulb
			bulb.loc = usr
		//	bulb.layer = ITEM_HUD_LAYER
			bulb.add_fingerprint(user)
			icon_state = "[gset]-n"
			bulb = null
		else
			user << "You need to loosen the screws on the light first"

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
			bulb.add_fingerprint(user)
	else if(istype(W, /obj/item/weapon/screwdriver))
		if(open == 0)
			open = 1
			user << "You unfasten the light bulb"
			oviewers(user,null) << text("[] has unfastened the lightbulb", user)
			bulb.add_fingerprint(user)
		else
			open = 0
			user << "You fasten the light bulb"
			oviewers(user,null) << text("[] has fastened the lightbulb", user)
			bulb.add_fingerprint(user)
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(src.grill == 1)
			oviewers(user, null) << text("[] has cut the grill of the []", user,src)
			user << "You cut the grill"
			src.grill = 0
		else
			oviewers(user, null) << text("[] has fixed the grill of the []", user,src)
			user << "You fix the grill"
			src.grill = 1
	else
		if(src.grill == 1)
			user << "You need to remove the grill first"
			return 0
		oviewers(user, null) << text("\red [] has smashed the []!", user, src)
		user << "\red You smash the [src.name]'s bulb with your [W.name]"
		stat |= BROKEN
		sd_SetLuminosity(0)
		on = 0
		icon_state = "[gset]-b"
		var/prot = 0
		bulb.add_fingerprint(user)
		if(istype(user, /mob/human))
			var/mob/human/H = user
			if(H.gloves)
				var/obj/item/weapon/clothing/gloves/G = H.gloves
				prot = G.elec_protect

		var/obj/effects/sparks/O = new /obj/effects/sparks( src.loc )
		O.dir = pick(NORTH, SOUTH, EAST, WEST)
		spawn( 0 )
			O.Life()
		if(prot == 10)		// elec insulted gloves protect completely
			return 0
		user.burn_skin(20)
		user << "\red <B>You feel a powerful shock course through your body!</B>"
		sleep(1)

		if(user.stunned < 20)	user.stunned = 20
		if(user.weakened < 20/prot)	user.weakened = 20/prot
		for(var/mob/M in viewers(src))
			if(M == user)	continue
			M.show_message("\red [user.name] was shocked by the [src.name]!", 3, "\red You hear a heavy electrical crack", 2)
		return 1

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
		area.use_power(150 * max(baselum, bulb.bright), LIGHT)

	bulb.use()

/obj/machinery/light/power_change()
	return

/obj/machinery/light/proc/turnon()
	if (!on)
		on = 1
		spawn(instant ? 0 : rand(3,13))
			if (on)
				updateicon()
				sd_SetLuminosity(bright())
//	else if (src.luminosity != bright())
//		sd_SetLuminosity(bright())
//		updateicon()

/obj/machinery/light/proc/turnoff()
	if (on)
		on = 0
		spawn(instant ? 0 : rand(1,2))
			if (!on)
				updateicon()
				sd_SetLuminosity(0)

/obj/item/weapon/storage/lightbulbs/New()
	..()
	new /obj/item/weapon/bulb( src )
	new /obj/item/weapon/bulb( src )
	new /obj/item/weapon/bulb( src )
	new /obj/item/weapon/bulb( src )
	new /obj/item/weapon/bulb( src )
	new /obj/item/weapon/bulb( src )
	new /obj/item/weapon/bulb( src )
	new /obj/item/weapon/bulb( src )