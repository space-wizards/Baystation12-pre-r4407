/obj/item/weapon/flash/attack(mob/M as mob, mob/user as mob)
	if (usr.clumsy && prob(50))
		usr << "\red The Flash slips out of your hand."
		usr.drop_item()
		return
	if (src.shots > 0)
		var/safety = null
		if (istype(M, /mob/human))
			var/mob/human/H = M
			if (istype(H.glasses, /obj/item/weapon/clothing/glasses/sunglasses))
				safety = 1
				if (rickroll == 1)
					status = 0
					usr << "\blue The failed rickroll depleted your modded flash's battery..."
					M << "\red You catch a faint glimpse of Rick Astley when you are unsuccessfully flashed..."
		if (!( safety ))
			if (M.client)
				if (status == 0)
					user << "\red The bulb has been burnt out!"
					return
				if (!( safety ) && status == 1)
					if (open == 0)
						if(!M.ishulk) M.weakened = 10
						if (user.is_rev == 2 && M.is_rev == 0)
							M.is_rev = 1
							M << "\blue You are now a revolutionary. Help your cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons (or use the \"memory\" command). Nota: Do not rat out or harm the one who flashed you! He is your leader now."
							for(var/mob/N in ticker.revs)
								N << image(icon = 'mob.dmi', loc = M, icon_state = "rev")
								M << image(icon = 'mob.dmi', loc = N, icon_state = "rev")
						if (prob(10))
							status = 0
							user << "\red The bulb has burnt out!"
							return
						if ((M.eye_stat > 15 && prob(M.eye_stat + 50)))
							flick("e_flash", M.flash)
							M.eye_stat += rand(1, 2)
						else
							flick("flash", M.flash)
							M.eye_stat += rand(0, 2)
						if (M.eye_stat >= 20)
							M << "\red You eyes start to burn badly!"
							M.disabilities |= BADVISION
							if (prob(M.eye_stat - 20 + 1))
								M << "\red You go blind!"
								M.sdisabilities |= BLIND
						if (rickroll == 1)
							M << sound('NGGYU_Music.midi')
							M << "\red YOU HAVE BEEN RICKROLLED!"
							status = 0
							usr << "\blue The rickroll depleted your modded flash's battery..."
					else usr << "\red You can't use the flash while it is open!"
		for(var/mob/O in viewers(user, null))
			if(status == 1)
				O.show_message(text("\red [] blinds [] with the flash!", user, M))
	src.attack_self(user, 1)
	return

/obj/item/weapon/flash/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if ((istype(W, /obj/item/weapon/screwdriver)))
		if (open == 0)
			icon_state = "flash_o"
			open = 1
		else
			icon_state = "flash"
			open = 0
	if ((istype(W, /obj/item/weapon/multitool)))
		if (open == 1)
			if (rickroll == 0)
				usr << "\blue You make a special mod to the flash with your multitool, hehe. *YOU HAVE ADDED THE LEGENDARY RICKROLL TO THE FLASH!*"
				rickroll = 1
			else
				usr << "\blue You un-modded the flash."
				rickroll = 0



/obj/item/weapon/flash/attack_self(mob/user as mob, flag)
	if (usr.clumsy && prob(50))
		usr << "\red The Flash slips out of your hand."
		usr.drop_item()
		return
	if ( (world.time + 600) > src.l_time)
		src.shots = 5
	if (src.shots < 1)
		user.show_message("\red *click* *click*", 2)
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.l_time = world.time
	add_fingerprint(user)
	src.shots--
	flick("flash2", src)
	if (!( flag ))
		for(var/mob/M in oviewers(3, null))
			if (prob(50))
				if (locate(/obj/item/weapon/cloaking_device, M))
					for(var/obj/item/weapon/cloaking_device/S in M)
						S.active = 0
						S.icon_state = "shield0"
			if (M.client)
				var/safety = null
				if (istype(M, /mob/human))
					var/mob/human/H = M
					if (istype(H.glasses, /obj/item/weapon/clothing/glasses/sunglasses))
						safety = 1
				if (!( safety ))
					flick("flash", M.flash)
	return
