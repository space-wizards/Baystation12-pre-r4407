/obj/item/weapon/sheet/metal/attack_hand(mob/user as mob)
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/sheet/metal/F = new /obj/item/weapon/sheet/metal( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 52
		F.add_fingerprint(user)
		if (src.amount < 1)
			del(src)
			return
	else
		..()
	src.force = 5
	return

/obj/item/weapon/sheet/metal/attackby(obj/item/weapon/sheet/metal/W as obj, mob/user as mob)
	if (!( istype(W, /obj/item/weapon/sheet/metal) ))
		return
	if (W.amount >= 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = W.amount + src.amount - 5
		W.amount = 5
	else
		W.amount += src.amount
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/sheet/metal/examine()
	set src in view(1)

	..()
	usr << text("There are [] metal sheet\s on the stack.", src.amount)
	return

/obj/item/weapon/sheet/metal/attack_self(mob/user as mob)
	var/t1 = text("<HTML><HEAD></HEAD><TT>Amount Left: [] <BR>", src.amount)
	var/counter = 1
	var/list/L = list(  )
	L["rods"] = "metal rods (makes 2)"
	L["stool"] = "stool"
	L["chair"] = "chair"
	L["table"] = "table parts (2)"
	L["rack"] = "rack parts"
	L["o2can"] = "o2 canister (2)"
	L["plcan"] = "pl canister (2)"
	L["closet"] = "closet (2)"
	L["fl_tiles"] = "floor tiles (makes 4)"
	L["reinforced"] = "reinforced sheet (2) (Doesn't stack)"
	L["construct"] = "construct wall"
	L["bed"] = "bed (2)"
	L["airlock"] = "airlock (5)"
	L["solar"] = "solar panel base (5)"
	L["comdisc"] = "Com Disc base (5)"
	L["solarcomp"] = "solar panel computer (5)"
	L["frame"] = "Computer Frame (4)"
	for(var/t in L)
		counter++
		t1 += text("<A href='?src=\ref[];make=[]'>[]</A>  ", src, t, L[t])
		if (counter > 2)
			counter = 1
			t1 += "<BR>"
	t1 += "</TT></HTML>"
	user << browse(t1, "window=met_sheet")
	return

/obj/item/weapon/sheet/metal/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.equipped() != src))
		return
	if (href_list["make"])
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
		switch(href_list["make"])
			if("rods")
				src.amount--
				var/obj/item/weapon/rods/R = new /obj/item/weapon/rods( usr.loc )
				R.amount = 2
			if("table")
				if (src.amount < 2)
					return
				src.amount -= 2
				new /obj/item/weapon/table_parts( usr.loc )
			if("stool")
				src.amount--
				new /obj/stool( usr.loc )
			if("chair")
				src.amount--
				var/obj/stool/chair/C = new /obj/stool/chair( usr.loc )
				C.dir = usr.dir
				if (C.dir == NORTH)
					C.layer = 5
			if("rack")
				src.amount--
				new /obj/item/weapon/rack_parts( usr.loc )
			if("o2can")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/obj/machinery/atmoalter/canister/oxygencanister/C = new /obj/machinery/atmoalter/canister/oxygencanister( usr.loc )
				C.gas.oxygen = 0
			if("plcan")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/obj/machinery/atmoalter/canister/poisoncanister/C = new /obj/machinery/atmoalter/canister/poisoncanister( usr.loc )
				C.gas.plasma = 0
			if("reinforced")
				if (src.amount < 2)
					return
				src.amount -= 2
				var/obj/item/weapon/sheet/r_metal/C = new /obj/item/weapon/sheet/r_metal( usr.loc )
				C.amount = 1
			if("closet")
				if (src.amount < 2)
					return
				src.amount -= 2
				new /obj/closet( usr.loc )
			if("fl_tiles")
				src.amount--
				var/obj/item/weapon/tile/R = new /obj/item/weapon/tile( usr.loc )
				R.amount = 4
			if("bed")
				if (src.amount < 2)
					return
				src.amount -= 2
				new /obj/stool/bed( usr.loc )
			if("construct")
				if (src.amount < 2)
					return
				var/turf/T = usr.loc
				if ((usr.loc == T))
					if (!istype(T, /turf/station/floor))
						return
					src.amount -= 2
					var/turf/station/wall/G = T.ReplaceWithWall()

					G.icon_state = "girder"
					G.updatecell = 1
					G.opacity = 0
					G.state = 1
					G.density = 1
					G.levelupdate()
					G.buildlinks()
			if("airlock")
				if (src.amount < 5)
					return
				var/turf/T = usr.loc
				if ((usr.loc == T))
					if (!istype(T, /turf/station/floor))
						return
					src.amount -= 5
					var/obj/machinery/door/airlock/C = new/obj/machinery/door/airlock
					C.req_access = list()
					C.loc = usr.loc
					C.build_state = 1
					C.loc.buildlinks()
					C.updateIconState()
			if("solarcomp")
				if (src.amount < 5)
					return
				var/turf/T = usr.loc
				if (!istype(T, /turf/station/floor))
					return
				src.amount -= 5
				var/obj/machinery/power/solar_control/S = new/obj/machinery/power/solar_control
				S.building=1
				S.updateicon()
				S.loc=T
				S.density=0
				S.id=""
			if("solar")
				if (src.amount < 5)
					return
				var/turf/T = usr.loc
				if (!istype(T, /turf/station/floor))
					return
				src.amount -= 5
				var/obj/machinery/power/solar/S = new/obj/machinery/power/solar
				S.building=1
				S.updateicon()
				S.loc=T
				S.density=0
				S.id=""
			if("comdisc")
				if (src.amount < 5)
					return
				var/turf/T = usr.loc
				if (!istype(T, /turf/station/floor))
					return
				src.amount -= 5
				var/obj/machinery/computer/comdisc/S = new/obj/machinery/computer/comdisc
				S.buildstate = 1
				S.updateicon()
				S.loc=T
				S.density=0
			if("frame")
				if (src.amount < 4)
					return
				src.amount -= 4
				var/obj/machinery/computer/frame/C = new/obj/machinery/computer/frame
				C.loc = usr.loc
				C.buildstate = 0
		if (src.amount <= 0)
			usr.u_equip(src)
			usr << browse(null, "window=met_sheet")
			del(src)
			return
	spawn( 0 )
		src.attack_self(usr)
		return
	return