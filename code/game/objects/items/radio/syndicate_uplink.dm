/obj/item/weapon/syndicate_uplink/proc/explode()
	var/turf/T = get_turf(src.loc)
	T.firelevel = T.poison
	T.res_vars()
	var/sw = locate(max(T.x - 4, 1), max(T.y - 4, 1), T.z)
	var/ne = locate(min(T.x + 4, world.maxx), min(T.y + 4, world.maxy), T.z)
	for(var/turf/U in block(sw, ne))
		var/zone = 4
		if ((U.y <= T.y + 2 && U.y >= T.y - 2 && U.x <= T.x + 2 && U.x >= T.x - 2))
			zone = 3
		for(var/atom/A as mob|obj|turf|area in U)
			A.ex_act(zone)
		U.ex_act(zone)
		U.buildlinks()
	del(src.master)
	del(src)
	return

/obj/item/weapon/syndicate_uplink/attack_self(mob/user as mob)
	user.machine = src
	var/dat
	if (src.selfdestruct)
		dat = "Self Destructing..."
	else
		if (src.temp)
			dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
		else
			dat = "<B>Syndicate Uplink Console:</B><BR>"
			dat += "Tele-Crystals left: [src.uses]<BR>"
			dat += "<HR>"
			dat += "<B>Request item:</B><BR>"
			dat += "<I>Each item costs a number of tele-crystals as indicated by the number following their name.</I><BR>"
			dat += "<A href='byond://?src=\ref[src];item_revolver_ammo=1'>Ammo-357</A> for use with Revolver (1)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_cyanide=1'>Cyanide Pill</A> (1)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_imp_freedom=1'>Freedom Implant (with injector)</A> (1)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_sleepypen=1'>Sleepy Pen</A> (1)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_card=1'>Syndicate Card</A> (1)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_emag=1'>Electromagnet Card</A> (2)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_ai_module=1'>Freeform AI Module</A> (2)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_revolver=1'>Revolver</A> (2)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_voice=1'>Voice-Changer</A> (2)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_cloak=1'>Cloaking Device</A> (3)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_sword=1'>Energy Sword</A> (3)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_bomb=1'>Timer/Igniter/Plasma Tank Assembly</A> (3)<BR>"
			dat += "<HR>"
			if (src.origradio)
				dat += "<A href='byond://?src=\ref[src];lock=1'>Lock</A><BR>"
				dat += "<HR>"
			dat += "<A href='byond://?src=\ref[src];selfdestruct=1'>Self-Destruct</A>"
	user << browse(dat, "window=radio")
	return

/obj/item/weapon/syndicate_uplink/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	var/mob/human/H = usr
	if (!( istype(H, /mob/human)))
		return 1
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["item_emag"])
			if (src.uses >= 2)
				src.uses -= 2
				new /obj/item/weapon/card/emag( H.loc )
		else if (href_list["item_sleepypen"])
			if (src.uses >= 1)
				src.uses -= 1
				new /obj/item/weapon/pen/sleepypen( H.loc )
		else if (href_list["item_cyanide"])
			if (src.uses >= 1)
				src.uses -= 1
				new /obj/item/weapon/m_pill/cyanide( H.loc )
		else if (href_list["item_cloak"])
			if (src.uses >= 3)
				src.uses -= 3
				new /obj/item/weapon/cloaking_device( H.loc )
		else if (href_list["item_revolver"])
			if (src.uses >= 2)
				src.uses -= 2
				var/obj/item/weapon/gun/revolver/O = new /obj/item/weapon/gun/revolver(H.loc)
				O.bullets = 7
		else if (href_list["item_revolver_ammo"])
			if (src.uses >= 1)
				src.uses -= 1
				new /obj/item/weapon/ammo/a357(H.loc)
		else if (href_list["item_voice"])
			if (src.uses >= 2)
				src.uses -= 2
				new /obj/item/weapon/clothing/mask/voicemask(H.loc)
		else if (href_list["item_imp_freedom"])
			if (src.uses >= 1)
				src.uses -= 1
				var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter(H.loc)
				O.imp = new /obj/item/weapon/implant/freedom(O)
				src.temp = "The implant is triggered by an emote and has a random amount of uses."
		else if (href_list["item_ai_module"])
			if (src.uses >= 2)
				src.uses -= 2
				new /obj/item/weapon/aiModule/freeform( H.loc )
		else if (href_list["item_bomb"])
			if (src.uses >= 3)
				src.uses -= 3
				new /obj/bomb/timer/syndicate(H.loc)
		else if (href_list["item_card"])
			if (src.uses >= 1)
				src.uses -= 1
				new /obj/item/weapon/card/id/syndicate(H.loc)
		else if (href_list["item_sword"])
			if (src.uses >= 3)
				src.uses -= 3
				new /obj/item/weapon/sword(H.loc)
		else if (href_list["lock"] && src.origradio)
			// presto chango, a regular radio again! (reset the freq too...)
			usr.machine = null
			usr << browse(null, "window=radio")
			var/obj/item/weapon/radio/T = src.origradio
			var/obj/item/weapon/syndicate_uplink/R = src
			R.loc = T
			T.loc = usr
			// R.layer = initial(R.layer)
			R.layer = 0
			if (usr.client)
				usr.client.screen -= R
			if (usr.r_hand == R)
				usr.u_equip(R)
				usr.r_hand = T
			else
				usr.u_equip(R)
				usr.l_hand = T
			R.loc = T
			T.layer = 52
			T.freq = initial(T.freq)
			T.attack_self(usr)
			return
		else if (href_list["selfdestruct"])
			src.temp = "<A href='byond://?src=\ref[src];selfdestruct2=1'>Self-Destruct</A>"
		else if (href_list["selfdestruct2"])
			src.selfdestruct = 1
			spawn (100)
				explode()
				return
		else
			if (href_list["temp"])
				src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return
