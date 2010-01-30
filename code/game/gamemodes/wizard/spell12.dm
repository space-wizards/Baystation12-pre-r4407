/mob/proc/teleport()
	set category = "Spells"
	set name = "Teleport"
	set desc="Teleport"
	if(usr.stat >= 2)
		usr << "Not when you're dead!"
		return
	if(!istype(usr:wear_suit, /obj/item/weapon/clothing/suit/wizrobe))
		usr << "I don't feel strong enough without my robe."
		return
	if(!istype(usr:shoes, /obj/item/weapon/clothing/shoes/sandal))
		usr << "I don't feel strong enough without my sandals."
		return
	if(!istype(usr:head, /obj/item/weapon/clothing/head/wizhat))
		usr << "I don't feel strong enough without my hat."
		return
	if(!istype(usr:l_hand, /obj/item/weapon/staff) && !istype(usr:r_hand, /obj/item/weapon/staff))
		usr << "I don't feel strong enough without my staff."
		return
//	set desc = "Area to jump to"
//	set src = usr

//	if(src.authenticated && src.holder)
	var/A
	usr.verbs -= /mob/proc/teleport
	spawn(450)
		usr.verbs += /mob/proc/teleport
	A = input("Area to jump to", "BOOYEA", A) in list("Engine","Hallways","Toxins","Storage","Maintenance","Crew Quarters","Medical","Security","Chapel","Bridge")

	switch (A)
		if ("Engine")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/engine) && !istype(B, /area/engine/combustion) && !istype(B, /area/engine/cooling) && !istype(B, /area/engine/engine_walls))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA ENGINE")
		if ("Hallways")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/hallway))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA HALLWAY")
		if ("Toxins")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/research) && !istype(B, /area/research/medical))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA TOXINS")
		if ("Storage")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/storage))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA STORAGE")
		if ("Maintenance")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/maintenance))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA MAINTENANCE")
		if ("Crew Quarters")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/crewquarters))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA CREW QUARTERS")
		if ("Medical")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/medical))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA MEDICAL")
		if ("Security")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/security))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA SECURITY")
		if ("Chapel")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/chapel))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA CHAPEL")
		if ("Bridge")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/administrative) && !istype(B, /area/administrative/court))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA BRIDGE")

	var/obj/effects/smoke/Y = new /obj/effects/smoke( usr.loc )
	Y.amount = 1
	Y.dir = pick(1, 2, 4, 8)
	spawn( 0 )
		Y.Life()
	var/list/L = list()
	for(var/turf/T in A)
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

//		usr << "\blue Jumping to [A]!"
//		world.log_admin("[usr.key] jumped to [A]")
//		messageadmins("[usr.key] jumped to [A]")

	usr.loc = pick(L)

	var/obj/effects/smoke/T = new /obj/effects/smoke( usr.loc )
	T.amount = 1
	T.dir = pick(1, 2, 4, 8)
	spawn( 0 )
		T.Life()

/mob/proc/teleportscroll()
	if(usr.stat >= 2)
		usr << "Not when you're dead!"
		return
	var/A
	A = input("Area to jump to", "BOOYEA", A) in list("Engine","Hallways","Toxins","Storage","Maintenance","Crew Quarters","Medical","Security","Chapel","Bridge")
	switch (A)
		if ("Engine")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/engine) && !istype(B, /area/engine/combustion) && !istype(B, /area/engine/engine_walls))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA ENGINE")
		if ("Hallways")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/hallway))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA HALLWAY")
		if ("Toxins")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/research) && !istype(B, /area/research/medical))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA TOXINS")
		if ("Storage")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/storage))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA STORAGE")
		if ("Maintenance")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/maintenance))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA MAINTENANCE")
		if ("Crew Quarters")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/crewquarters))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA CREW QUARTERS")
		if ("Medical")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/medical))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA MEDICAL")
		if ("Security")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/security))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA SECURITY")
		if ("Chapel")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/chapel))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA CHAPEL")
		if ("Bridge")
			var/list/L = list()
			for(var/area/B in world)
				if(istype(B, /area/administrative) && !istype(B, /area/administrative/court))
					L += B
			A = pick(L)
			usr.say("SCYAR NILA BRIDGE")

	var/obj/effects/smoke/Y = new /obj/effects/smoke( usr.loc )
	Y.amount = 1
	Y.dir = pick(1, 2, 4, 8)
	spawn( 0 )
		Y.Life()
	var/list/L = list()
	for(var/turf/T in A)
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	usr.loc = pick(L)

	var/obj/effects/smoke/T = new /obj/effects/smoke( usr.loc )
	T.amount = 1
	T.dir = pick(1, 2, 4, 8)
	spawn( 0 )
		T.Life()