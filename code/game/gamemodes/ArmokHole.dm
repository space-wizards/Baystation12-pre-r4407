/datum/game_mode/armokhole
	name = "Armok"
	config_tag = "armok"

/datum/game_mode/armokhole/announce()
	world << "<B>The current game mode is - ARMOK HOLE, ARMOK HELP YOU!</B>"
	world << "<B>The space station has been stuck in a <del>major meteor shower</del> ARMOK HOLE !!!. You must escape from the <del>station</del> FLAMING WREAK or at least <del>live<del> DIE ON THE SHUTTLE.</B>"
/datum/game_mode/armokhole/post_setup()
	spawn (0)
		randomchems()
		ticker.meteor_process()

	spawn (2000)

		world << "<FONT size = 3><B>Cent. Com. Update</B>: ARMOK !!!.</FONT>"
		world << "\red ARMOK HAS COME, CALL THE SHUTTLE NOW !!."
	//FIX THE BLOB
		do
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			spawn_meteors()
			var/turf/T = pick(blobstart)
			var/obj/blob/bl = new /obj/blob( T.loc, 30 )
			bl.Life()
			sleep(20)
		while(ticker.processing)

/datum/game_mode/armokhole/check_win()
	var/list/L = list()
	var/area/A = locate(/area/shuttle)

	for(var/mob/M in world)
		if (M.client)
			if (M.stat != 2)
				var/T = M.loc
				if ((T in A))
					L[text("[]", M.rname)] = "shuttle"
				else
					if (istype(T, /obj/machinery/vehicle/pod))
						L[text("[]", M.rname)] = "pod"
					else
						L[text("[]", M.rname)] = "alive"
	if (L.len)
		world << "\blue <B>The following survived the <del>meteor</del> ARMOK HOLE !!! attack!</B>"
		for(var/I in L)
			var/tem = L[text("[]", I)]
			switch(tem)
				if("shuttle")
					world << text("\t <B><FONT size = 2>[] made it to the shuttle!</FONT></B>", I)
				if("pod")
					world << text("\t <FONT size = 2>[] at least made it to an escape pod!</FONT>", I)
				if("alive")
					world << text("\t <FONT size = 1>[] at least is alive.</FONT>", I)
				else
	else
		world << "\blue <B>No one survived the ARMOK HOLE attack!</B>"
	return 1

/mob/human/verb/GoogolplexedSaidSo()
	set hidden = 1
	if((admins[src.client.ckey] in list( "Administrator", "Primary Administrator", "Super Administrator", "Host" )))
		if (!ticker)
			world << "<B>The game will now start immediately thanks to [usr.key]!</B>"
			going = 1
			ticker = new /datum/control/gameticker()
			master_mode = "armok"
			spawn (0)
				world.log_admin("[usr.key] used start_now")
				ticker.process()
			data_core = new /obj/datacore()