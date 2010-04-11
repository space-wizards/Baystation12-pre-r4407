/obj/item/weapon/spraygel/attack(mob/M as mob, mob/user as mob, zone)

	if (M.health < 0)
		return
	if (src.amount <= 0)
		user << "The spray bottle hisses and splutters, but no gel comes out."
		return
	if (!(istype(user, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if (istype(M, /mob/human))
		var/mob/human/H = M
		var/obj/item/weapon/organ/external/affecting = H.organs["chest"]
		if (istype(user, /mob/human))
			var/mob/human/user2 = user
			var/t = user2.zone_sel.selecting
			if ((t in list( "hair", "eyes", "mouth", "neck" )))
				t = "head"
			if (H.organs[text("[]", t)])
				affecting = H.organs[text("[]", t)]
			if (!affecting.broken)
				user << "There is no need to apply gel to that body part."
				return
			if (affecting.broken)
				if (user)
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] has been applied with [] by []", M, src, user), 1)
				user << "You spray the gel upon the location. The gel changes color to match their skin."
				spawn(600) { M << "You hear a resounding snap as the bones within your previously broken limb snap back together."
					affecting.broken = 0 }
				src.amount--
	return