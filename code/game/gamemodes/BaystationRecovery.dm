/proc/WreakStation()

	// tables
	for(var/obj/table/T in world)
		if(prob(30))
			new /obj/item/weapon/table_parts( T.loc )
			del(T)

	var/list/Wrecks = list()
	// Closets
	for(var/obj/closet/C in world)
		if(prob(10) && C.z==1)
			Wrecks += C
	// Items
	for(var/obj/item/weapon/W in world)
		if(isturf(W.loc) || isobj(W.loc))
			if(prob(12))
				Wrecks += W
	for(var/obj/machinery/atmoalter/canister/C in world)
		if(C.z==1 && prob(40))
			Wrecks += C
	for(var/obj/machinery/vehicle/V in world)
		if(V.z==1 && prob(80))
			Wrecks += V
	// delete em
	for(var/obj/O in Wrecks)
		del (O)

	// secure closets
	for(var/obj/secloset/S in world)
		if(S.z==1 && prob(26))
			S.locked = !(S.locked)
			S.icon_state = text("[]secloset0", (S.locked ? "1" : null))
		if(prob(10))
			S.broken = 1


	// Make corpses
	for(var/mob/monkey/M in world)
		if(!M.client)
			M.toxloss = 200
			M.ex_act(1)
			M.ex_act(1)

	for(var/mob/human/M in world)
		if(!M.client)
			M.toxloss = 200
			M.ex_act(1)
			M.ex_act(1)





	// open doors
	for(var/obj/machinery/door/airlock/D in world)
		if(D.z==1 && prob(70))
			spawn()
				D.open()
				D.locked = 1
		if(prob(80))
			D.cut(pick(list("Orange","Dark red","White","Yellow","Red","Blue","Green","Grey","Black")))
			if(prob(70))
				D.cut(pick(list("Orange","Dark red","White","Yellow","Red","Blue","Green","Grey","Black")))
			if(prob(70))
				D.cut(pick(list("Orange","Dark red","White","Yellow","Red","Blue","Green","Grey","Black")))
	for(var/obj/machinery/door/window/D in world)
		if(D.z==1 && prob(70))
			spawn()
				D.open()

	// disable power
	for(var/obj/machinery/power/apc/A in world)
		if(A.z==1 && prob(40))
			A.operating = 0
		if(A.cell != null)
			A.cell.charge = 0
		A.cut(pick(list("Orange","Dark red","White","Yellow")))

		if(prob(40))
			A.locked = 0
		if(prob(40))
			A.coverlocked = 0
		if(prob(20))
			A.coverlocked = 0
			A.opened = 1
		if(prob(10) && A.cell != null)
			del(A.cell)

	for(var/obj/machinery/power/smes/S in world)
		S.charge = 0

	// grilles and windows
	for(var/obj/grille/g in world)
		if(g.z==1 && prob(40))
			for(var/obj/window/w in g.loc)
				if(prob(40))
					w.ex_act(1)
			g.ex_act(2)
	for(var/obj/window/w in world)
		if(w.z==1 && prob(10))
			w.ex_act(2)

	// floors
	for(var/turf/station/floor/Z in world)
		if(prob(30))
			Z.health = 100
			Z.burnt	= 1
			Z.intact = 0
			Z.levelupdate()
			Z.icon_state = text("Floor[]", (Z.burnt ? "1" : ""))
		if(prob(5))
			Z.add_blood(null)
	for(var/obj/machinery/atmoalter/canister/C in world)
		if(prob(20))
			C.destroyed = 1
