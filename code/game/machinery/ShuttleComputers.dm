/obj/machinery/computer/prison_shuttle/verb/take_off()
	set name = "Take Off"
	set src in oview(1)

	if (usr.stat || usr.restrained())
		return

	src.add_fingerprint(usr)
	if(!src.allowedtocall)
		usr << "\red The console seems irreparably damaged!"
		return
	if(src.z == shuttle_en_route_level)
		usr << "\red Already in transit! Please wait!"
		return
	var/area/A = locate(/area/shuttle_prison)

	for(var/area/B in A.superarea.areas)
		for(var/mob/M in B)
			M.show_message("\red Launch sequence initiated!")
			spawn(0)
				shake_camera(M, 10, 1)
	sleep(10)

	if(src.z == prison_shuttle_dock)	//This is the laziest proc ever
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = station_prison_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Prison shuttle has arrived at destination!")
				spawn(0)	shake_camera(M, 2, 1)
	else
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = prison_shuttle_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Prison shuttle has arrived at destination!")
				spawn(0)	shake_camera(M, 2, 1)

/obj/machinery/computer/prison_shuttle/verb/restabalize()
	set src in oview(1)

	src.add_fingerprint(usr)

	var/area/B = locate(/area/shuttle_prison)
	for(var/area/A in B.superarea.areas)
		for(var/mob/M in A)
			M.show_message("\red <B>Restabilizing prison shuttle atmosphere!</B>")

		for(var/obj/move/T in A)
			T.firelevel = 0
			T.oxygen = O2STANDARD
			T.oldoxy = O2STANDARD
			T.tmpoxy = O2STANDARD
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.co2 = 0
			T.oldco2 = 0
			T.tmpco2 = 0
			T.sl_gas = 0
			T.osl_gas = 0
			T.tsl_gas = 0
			T.n2 = N2STANDARD
			T.on2 = N2STANDARD
			T.tn2 = N2STANDARD
			T.temp = T20C
			T.otemp = T20C
			T.ttemp = T20C
			sleep(1)

		for(var/mob/M in A)
			M.show_message("\red <B>Prison shuttle atmosphere restabilized!</B>")
	return

/obj/machinery/computer/sydi_shuttle/verb/take_off()
	set src in oview(1)

	if (usr.stat || usr.restrained())
		return

	src.add_fingerprint(usr)
	if(src.z == shuttle_en_route_level)
		usr << "\red Already in transit! Please wait!"
		return
	sleep(10)

	var/area/A = locate(/area/syndicate_ship)
	for(var/area/B in A.superarea.areas)
		for(var/mob/M in B)
			M.show_message("\red Launch sequence initiated!")
			spawn(0)	shake_camera(M, 10, 1)

	sleep(10)

	if(src.z == syndicate_shuttle_dock)	//This is the laziest proc ever
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = station_syndicate_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Syndicate shuttle has arrived at destination!")
				spawn(0)	shake_camera(M, 2, 1)
	else
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = syndicate_shuttle_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Syndicate shuttle has arrived at destination!")
				spawn(0)	shake_camera(M, 2, 1)


/obj/machinery/computer/supply_shuttle/verb/take_off()
	set name = "Take Off"
	var/area/A = locate(/area/shuttle_supply)
	for(var/area/B in A.superarea.areas)
		for(var/mob/M in B)
			M.show_message("\red Launch sequence initiated!")
			spawn(0)	shake_camera(M, 10, 1)
		sleep(10)
	world << shuttle_en_route_level
	if(src.z == centcom_supply_dock)
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = station_supply_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Supply shuttle has arrived at destination!")
				spawn(0)	shake_camera(M, 2, 1)
	else
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = centcom_supply_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Supply shuttle has arrived at destination!")
				spawn(0)	shake_camera(M, 2, 1)

/obj/machinery/computer/supply_shuttle/verb/restabalize()
	set src in oview(1)

	src.add_fingerprint(usr)

	var/area/B = locate(/area/shuttle_prison)
	for(var/area/A in B.superarea.areas)
		for(var/mob/M in A)
			M.show_message("\red <B>Restabilizing supply shuttle atmosphere!</B>")

		for(var/obj/move/T in A)
			T.firelevel = 0
			T.oxygen = O2STANDARD
			T.oldoxy = O2STANDARD
			T.tmpoxy = O2STANDARD
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.co2 = 0
			T.oldco2 = 0
			T.tmpco2 = 0
			T.sl_gas = 0
			T.osl_gas = 0
			T.tsl_gas = 0
			T.n2 = N2STANDARD
			T.on2 = N2STANDARD
			T.tn2 = N2STANDARD
			T.temp = T20C
			T.otemp = T20C
			T.ttemp = T20C
			sleep(1)
		for(var/mob/M in A)
			M.show_message("\red <B>Supply shuttle atmosphere restabilized!</B>")
	return


/obj/machinery/computer/shuttle/verb/restabalize()
/*
	set src in oview(1)

	world << "\red <B>Restabalizing shuttle atmosphere!</B>"
	var/A = locate(/area/shuttle)
	for(var/obj/move/T in A)
		T.firelevel = 0
		T.oxygen = O2STANDARD
		T.oldoxy = O2STANDARD
		T.tmpoxy = O2STANDARD
		T.poison = 0
		T.oldpoison = 0
		T.tmppoison = 0
		T.co2 = 0
		T.oldco2 = 0
		T.tmpco2 = 0
		T.sl_gas = 0
		T.osl_gas = 0
		T.tsl_gas = 0
		T.n2 = N2STANDARD
		T.on2 = N2STANDARD
		T.tn2 = N2STANDARD
		T.temp = T20C
		T.otemp = T20C
		T.ttemp = T20C
		//Foreach goto(35)
	world << "\red <B>Shuttle Restabalized!</B>"
	src.add_fingerprint(usr)
	return*/
	set src in oview(1)

	src.add_fingerprint(usr)

	var/area/B = locate(/area/shuttle_prison)
	for(var/area/A in B.superarea.areas)
		for(var/mob/M in A)
			M.show_message("\red <B>Restabilizing emergency shuttle atmosphere!</B>")

		for(var/obj/move/T in A)
			T.firelevel = 0
			T.oxygen = O2STANDARD
			T.oldoxy = O2STANDARD
			T.tmpoxy = O2STANDARD
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.co2 = 0
			T.oldco2 = 0
			T.tmpco2 = 0
			T.sl_gas = 0
			T.osl_gas = 0
			T.tsl_gas = 0
			T.n2 = N2STANDARD
			T.on2 = N2STANDARD
			T.tn2 = N2STANDARD
			T.temp = T20C
			T.otemp = T20C
			T.ttemp = T20C
			sleep(1)
		for(var/mob/M in A)
			M.show_message("\red <B>Emergency shuttle atmosphere restabilized!</B>")
	return

/obj/machinery/computer/shuttle/attackby(var/obj/item/weapon/card/id/W as obj, var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	if ((!( istype(W, /obj/item/weapon/card/id) ) || !( ticker ) || ticker.shuttle_location == shuttle_z || !( user )))
		return
	if (!W.access) //no access
		user << "The access level of [W.registered]\'s card is not high enough. "
		return
	var/list/cardaccess = W.access
	if(!istype(cardaccess, /list) || !cardaccess.len) //no access
		user << "The access level of [W.registered]\'s card is not high enough. "
		return
	var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
	switch(choice)
		if("Authorize")
			src.authorized -= W.registered
			src.authorized += W.registered
			if (src.auth_need - src.authorized.len > 0)
				world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)
			else
				world << "\blue <B>Alert: Shuttle launch time shortened to 10 seconds!</B>"
				ticker.timeleft = 100
				//src.authorized = null
				del(src.authorized)
				src.authorized = list(  )
		if("Repeal")
			src.authorized -= W.registered
			world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)
		if("Abort")
			world << "\blue <B>All authorizations to shorting time for shuttle launch have been revoked!</B>"
			src.authorized.len = 0
			src.authorized = list(  )
		else
	return

/obj/shut_controller/proc/rotate(direct)

	var/SE_X = 1
	var/SE_Y = 1
	var/SW_X = 1
	var/SW_Y = 1
	var/NE_X = 1
	var/NE_Y = 1
	var/NW_X = 1
	var/NW_Y = 1
	for(var/obj/move/M in src.parts)
		if (M.x < SW_X)
			SW_X = M.x
		if (M.x > SE_X)
			SE_X = M.x
		if (M.y < SW_Y)
			SW_Y = M.y
		if (M.y > NW_Y)
			NW_Y = M.y
		if (M.y > NE_Y)
			NE_Y = M.y
		if (M.y < SE_Y)
			SE_Y = M.y
		if (M.x > NE_X)
			NE_X = M.x
		if (M.x < NW_X)
			NW_X = M.y
	var/length = abs(NE_X - NW_X)
	var/width = abs(NE_Y - SE_Y)
	var/obj/random = pick(src.parts)
	var/s_direct = null
	switch(s_direct)
		if(1.0)
			switch(direct)
				if(90.0)
					var/tx = SE_X
					var/ty = SE_Y
					var/t_z = random.z
					for(var/obj/move/M in src.parts)
						M.ty =  -M.x - tx
						M.tx =  -M.y - ty
						var/T = locate(M.x, M.y, 11)
						M.relocate(T)
						M.ty =  -M.ty
						M.tx += length
						//Foreach goto(374)
					for(var/obj/move/M in src.parts)
						M.tx += tx
						M.ty += ty
						var/T = locate(M.tx, M.ty, t_z)
						M.relocate(T, 90)
						//Foreach goto(468)
				if(-90.0)
					var/tx = SE_X
					var/ty = SE_Y
					var/t_z = random.z
					for(var/obj/move/M in src.parts)
						M.ty = M.x - tx
						M.tx = M.y - ty
						var/T = locate(M.x, M.y, 11)
						M.relocate(T)
						M.ty =  -M.ty
						M.ty += width
						//Foreach goto(571)
					for(var/obj/move/M in src.parts)
						M.tx += tx
						M.ty += ty
						var/T = locate(M.tx, M.ty, t_z)
						M.relocate(T, -90.0)
						//Foreach goto(663)
				else
		else
	return

/obj/machinery/computer/supply/proc/show_supply_shuttle_menu(var/mob/user)
	user.machine = null
	var/dat = ""
	if(supply_shuttle_z == centcom_supply_dock)
		dat += "[supply_shuttle_points] requisition points remaining<br><br>"

		dat += "<A HREF='?src=\ref[src];supply_request=metal'>50 metal sheets(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=glass'>50 glass sheets(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=circuit'>Circuitry(5)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=cable'>Cable(5)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=paper'>Box of paper(1)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=internals'>Emergency closet(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=weldfuel'>Welder fuel(20)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=siphon'>Portable siphon(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=scrubber'>Portable air scrubber(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=can_air'>Air canister(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=can_n2o'>N2O canister(20)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=can_o2'>Oxygen canister(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=can_co2'>CO2 canister(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=can_n2'>Nitrogen canister(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=can_plasma'>Plasma canister(25)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=cell'>Spare power cell(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=tank_oxy'>Oxygen tank(5)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=tank_plasma'>Plasma tank(20)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=jetpack'>jetpack(25)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=toolbox'>toolbox(20)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=toolbox_e'>electrical toolbox(20)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=aid'>First aid kit(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=aid_fire'>Fire first aid kit(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=aid_tox'>Toxins first aid kit(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=cuffs'>Spare Handcuffs(30)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=pen'>Spare pen(1)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=mop'>Mop(8)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=beer'>Space beer(6)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=extinguisher'>Fire extinguisher(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=muzzle'>Muzzle(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=s_suit'>Space suit(20)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=s_helm'>Space helmet(20)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=e_glove'>Electrical gloves(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=blindfold'>Blindfold(10)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=S_jacket'>Straightjacket(15)</A><br>"
		dat += "<A HREF='?src=\ref[src];supply_request=stun'>Stun baton(15)</A><br>"
		//dat += "<A HREF='?src=\ref[src];supply_request=bear'>Space bear(50)</A><br>"

		dat += "<BR>\[ <A HREF='?src=\ref[src];operation=call-supply'>Send Shutle</A> \]"
	else if(supply_shuttle_z == station_supply_dock)
		dat += "<BR>\[ <A HREF='?src=\ref[src];operation=call-supply'>Return Shutle</A> \]"
	else
		dat += "Supply shuttle in transit"
	if(!longradio)
		dat = "Warning Communication Dish either out of order or is not alligned properly."
		dat += "<A HREF='?src=\ref[user];mach_close=supply_request'>Close</A> \]"
	user << browse(dat, "window=supply_request;size=400x500")

/obj/machinery/computer/supply/proc/supply_shuttle_request(var/mob/user,var/supply)
	if(supply_shuttle_z == centcom_supply_dock)
		var/area/A = locate(/area/shuttle_supply)
		var/list/B = list()
		var/full
		for(var/area/C in A.superarea.areas)
			for(var/obj/move/floor/F in C)
				full = 0
				for(var/atom/movable/MA in F.loc.contents)
					full++
				if(full < 2)
					B += F
		if(!B.len)
			user << "\red There is not enough space in the shuttle. Ensure that it is unloaded and does not have stowaways next time"
			return
		var/obj/move/floor/F = pick(B)
		var/req = 0
		switch(supply)
			if("metal")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/item/weapon/sheet/metal/I = new
					I.loc = F.loc
					I.amount = 50
				else req = 1
			if("glass")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/item/weapon/sheet/glass/I = new
					I.loc = F.loc
					I.amount = 50
				else req = 1
			if("circuit")
				if(supply_shuttle_points >= 5)
					supply_shuttle_points -= 5
					var/obj/item/weapon/circuitry/I = new
					I.loc = F.loc
				else req = 1
			if("cable")
				if(supply_shuttle_points >= 5)
					supply_shuttle_points -= 5
					var/obj/item/weapon/cable_coil/I = new
					I.loc = F.loc
				else req = 1
			if("paper")
				if(supply_shuttle_points >= 1)
					supply_shuttle_points -= 1
					var/obj/item/weapon/paper_bin/I = new
					I.loc = F.loc
				else req = 1
			if("internals")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/closet/emcloset/I = new
					I.loc = F.loc
				else req = 1
			if("weldfuel")
				if(supply_shuttle_points >= 20)
					supply_shuttle_points -= 20
					var/obj/weldfueltank/I = new
					I.loc = F.loc
				else req = 1
			if("siphon")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/machinery/atmoalter/siphs/fullairsiphon/port/I = new
					I.loc = F.loc
				else req = 1
			if("scrubber")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/machinery/atmoalter/siphs/scrubbers/port/I = new
					I.loc = F.loc
				else req = 1
			if("can_air")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/machinery/atmoalter/canister/aircanister/I = new
					I.loc = F.loc
				else req = 1
			if("can_n2o")
				if(supply_shuttle_points >= 20)
					supply_shuttle_points -= 20
					var/obj/machinery/atmoalter/canister/anesthcanister/I = new
					I.loc = F.loc
				else req = 1
			if("can_n2")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/machinery/atmoalter/canister/n2canister/I = new
					I.loc = F.loc
				else req = 1
			if("can_o2")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/machinery/atmoalter/canister/oxygencanister/I = new
					I.loc = F.loc
				else req = 1
			if("can_co2")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/machinery/atmoalter/canister/co2canister/I = new
					I.loc = F.loc
				else req = 1
			if("can_plasma")
				if(supply_shuttle_points >= 25)
					supply_shuttle_points -= 25
					var/obj/machinery/atmoalter/canister/poisoncanister/I = new
					I.loc = F.loc
				else req = 1
			if("cell")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/item/weapon/cell/I = new
					I.loc = F.loc
				else req = 1
			if("tank_oxy")
				if(supply_shuttle_points >= 5)
					supply_shuttle_points -= 5
					var/obj/item/weapon/tank/oxygentank/I = new
					I.loc = F.loc
				else req = 1
			if("tank_plasma")
				if(supply_shuttle_points >= 20)
					supply_shuttle_points -= 20
					var/obj/item/weapon/tank/plasmatank/I = new
					I.loc = F.loc
				else req = 1
			if("jetpack")
				if(supply_shuttle_points >= 25)
					supply_shuttle_points -= 25
					var/obj/item/weapon/tank/jetpack/I = new
					I.loc = F.loc
				else req = 1
			if("toolbox")
				if(supply_shuttle_points >= 20)
					supply_shuttle_points -= 20
					var/obj/item/weapon/storage/toolbox/I = new
					I.loc = F.loc
				else req = 1
			if("toolbox_e")
				if(supply_shuttle_points >= 20)
					supply_shuttle_points -= 20
					var/obj/item/weapon/storage/toolbox/electrical/I = new
					I.loc = F.loc
				else req = 1
			if("cuffs")
				if(supply_shuttle_points >= 30)
					supply_shuttle_points -= 30
					var/obj/item/weapon/storage/handcuff_kit/I = new
					I.loc = F.loc
				else req = 1
			if("aid")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/item/weapon/storage/firstaid/regular/I = new
					I.loc = F.loc
				else req = 1
			if("aid_tox")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/item/weapon/storage/firstaid/toxin/I = new
					I.loc = F.loc
				else req = 1
			if("aid_fire")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/item/weapon/storage/firstaid/fire/I = new
					I.loc = F.loc
				else req = 1
			if("pen")
				if(supply_shuttle_points >= 1)
					supply_shuttle_points -= 1
					var/obj/item/weapon/pen/I = new
					I.loc = F.loc
				else req = 1
			if("mop")
				if(supply_shuttle_points >= 8)
					supply_shuttle_points -= 8
					var/obj/item/weapon/mop/I = new
					I.loc = F.loc
				else req = 1
			if("beer")
				if(supply_shuttle_points >= 6)
					supply_shuttle_points -= 6
					var/obj/item/weapon/drink/beer/I = new
					I.loc = F.loc
				else req = 1
			if("extinguisher")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/item/weapon/extinguisher/I = new
					I.loc = F.loc
				else req = 1
			if("muzzle")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/item/weapon/clothing/mask/muzzle/I = new
					I.loc = F.loc
				else req = 1
			if("s_suit")
				if(supply_shuttle_points >= 20)
					supply_shuttle_points -= 20
					var/obj/item/weapon/clothing/suit/sp_suit/I = new
					I.loc = F.loc
				else req = 1
			if("s_helm")
				if(supply_shuttle_points >= 20)
					supply_shuttle_points -= 20
					var/obj/item/weapon/clothing/head/s_helmet/I = new
					I.loc = F.loc
				else req = 1
			if("e_glove")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/item/weapon/clothing/gloves/yellow/I = new
					I.loc = F.loc
				else req = 1
			if("blindfold")
				if(supply_shuttle_points >= 10)
					supply_shuttle_points -= 10
					var/obj/item/weapon/clothing/glasses/blindfold/I = new
					I.loc = F.loc
				else req = 1
			if("s_jacket")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/item/weapon/clothing/suit/straight_jacket/I = new
					I.loc = F.loc
				else req = 1
			if("stun")
				if(supply_shuttle_points >= 15)
					supply_shuttle_points -= 15
					var/obj/item/weapon/baton/I = new
					I.loc = F.loc
				else req = 1

		if(req)
			user << "\red Unable to order: Not enough requisition points remaining"

	else
		user << "\red Shuttle not in dock at supply station. Unabe to request items"