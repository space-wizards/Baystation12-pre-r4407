var/supply_shuttle_z = 2
var/supply_shuttle_points = 50

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

/proc/call_supply_shuttle(var/mob/user)
	if (!( ticker ))
		return

	if(supply_shuttle_z == centcom_supply_dock)	//This is the laziest proc ever
		user << "The supply shuttle has been called"
		var/area/A = locate(/area/shuttle_supply)
		for(var/area/B in A.superarea.areas)
			for(var/mob/M in B)
				M.show_message("\red Launch sequence initiated!")
				spawn(0)	shake_camera(M, 10, 1)
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		supply_shuttle_z = shuttle_en_route_level
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = station_supply_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Supply shuttle has arrived at station!")
				spawn(0)	shake_camera(M, 2, 1)
		supply_shuttle_z = station_supply_dock
	else if (supply_shuttle_z == station_supply_dock)
		user << "The supply shuttle has been sent back to CentCom \[[centcom_supply_dock]]"
		var/area/A = locate(/area/shuttle_supply)
		for(var/area/B in A.superarea.areas)
			for(var/mob/M in B)
				M.show_message("\red Launch sequence initiated!")
				spawn(0)	shake_camera(M, 10, 1)
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = shuttle_en_route_level
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		supply_shuttle_z = shuttle_en_route_level
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				AM.z = centcom_supply_dock
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Supply shuttle has arrived at Centcom!")
				spawn(0)	shake_camera(M, 2, 1)
		supply_shuttle_z = centcom_supply_dock
	else
		user << "\red Supply shuttle in transit already"
	if(0)world << "send shuttle 5"
