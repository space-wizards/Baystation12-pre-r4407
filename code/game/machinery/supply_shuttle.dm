var/supply_shuttle_z = 2
var/supply_shuttle_points = 50

/obj/machinery/computer/communications/proc/show_supply_shuttle_menu(var/mob/user)
	user.machine = null
	var/dat = ""
	if(supply_shuttle_z == 2)
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
	else if(supply_shuttle_z == 1)
		dat += "<BR>\[ <A HREF='?src=\ref[src];operation=call-supply'>Return Shutle</A> \]"
	else
		dat += "Supply shuttle in transit"
	user << browse(dat, "window=supply_request;size=400x500")

/obj/machinery/computer/communications/proc/supply_shuttle_request(var/mob/user,var/supply)
	//user << "Supplies! [supply]"
	if(supply_shuttle_z == 2)
		var/A = locate(/area/shuttle_supply)
		var/list/B = list()
		var/full
		for(var/obj/move/floor/F in A)
			full = 0
			for(var/atom/movable/MA in F.loc.contents)
				full++
			if(full < 2)//floor is one of them.
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
			/*if("bear")
				if(supply_shuttle_points >= 50)
					supply_shuttle_points -= 50
					var/mob/monkey/I = new
					I.loc = F.loc
					I.name = "Space Bear"
					I.rname = "Space Bear"
				else req = 1*/

		if(req)
			user << "\red Unable to order: Not enough requisition points remaining"

	else
		user << "\red Shuttle not in dock at supply station. Unabe to request items"

/proc/call_supply_shuttle(var/mob/user)
	if(0)world << "send shuttle"
	if (!( ticker ))
		return

	if(0)world << "send shuttle 2"
	/*if(ticker.mode.name == "blob" || ticker.mode.name == "Corporate Restructuring" || ticker.mode.name == "sandbox")
		user << "Under directive 7-10, SS13 is quarantined until further notice."
		return
	if(ticker.mode.name == "revolution")
		user << "Centcom will not allow the shuttle to be called, due to the possibility of sabotage by revolutionaries."
		return
	if(ticker.mode.name == "AI malfunction")
		user << "Centcom will not allow the shuttle to be called."
		return*/

	/*for(var/obj/machinery/computer/supply_shuttle/SS in world)
		if(!SS.allowedtocall)
			usr << "\red Centcom will not allow the shuttle to be called"
			return
		if(SS.z == 3)
			usr << "\red Already in transit! Please wait!"
			return
		var/A = locate(/area/shuttle_supply)
		for(var/mob/M in A)
			M.show_message("\red Launch sequence initiated!")
			spawn(0)	shake_camera(M, 10, 1)
		sleep(10)

		if(SS.z == 2)	//This is the laziest proc ever
			for(var/atom/movable/AM as mob|obj in A)
				AM.z = 3
				AM.Move()
			for(var/turf/T as turf in A)
				T.buildlinks()
			sleep(rand(600,1800))
			for(var/atom/movable/AM as mob|obj in A)
				AM.z = 1
				AM.Move()
			for(var/turf/T as turf in A)
				T.buildlinks()
		else
			for(var/atom/movable/AM as mob|obj in A)
				AM.z = 3
				AM.Move()
			for(var/turf/T as turf in A)
				T.buildlinks()
			sleep(rand(600,1800))
			for(var/atom/movable/AM as mob|obj in A)
				AM.z = 2
				AM.Move()
			for(var/turf/T as turf in A)
				T.buildlinks()
		for(var/mob/M in A)
			M.show_message("\red Supply shuttle has arrived at destination!")
		return
	return*/
	if(supply_shuttle_z == 1 || supply_shuttle_z == 2)
		if(0)world << "send shuttle 3"
		var/A = locate(/area/shuttle_supply)
		var/list/B = list()
		for(var/atom/movable/M in A)
			if(M.z == supply_shuttle_z)
				B+=M
		if(supply_shuttle_z == 1)
			if(0)world << "send shuttle 4a"
			supply_shuttle_z = 3
			for(var/atom/movable/M in B)
				M.z = 3
			sleep(1200)
			for(var/atom/movable/M in B)
				M.z = 2
			supply_shuttle_points = 50
			supply_shuttle_z = 2
		else if(supply_shuttle_z == 2)
			if(0)world << "send shuttle 4b"
			supply_shuttle_z = 3
			for(var/atom/movable/M in B)
				M.z = 3
			sleep(1200)
			for(var/atom/movable/M in B)
				M.z = 1
			supply_shuttle_z = 1
	else
		user << "\red Supply shuttle in transit already"
	if(0)world << "send shuttle 5"
