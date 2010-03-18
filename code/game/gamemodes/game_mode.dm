/datum/game_mode
	var/name = "invalid"
	var/config_tag = null
	var/votable = 1
	var/probability = 1

// Default check win
/datum/game_mode/proc/announce()
	world << "<B>[src] did not define announce()</B>"

/datum/game_mode/proc/pre_setup()
	return

/datum/game_mode/proc/post_setup()
	spawn (3000)
		start_events()
	spawn (0)
		ticker.extend_process()
	spawn ((18000+rand(3000)))
		force_event()
	spawn (1200)
		var/hardban[]
		hardban = list("Justgoaway1")
		for(var/mob/M in world)
			if (hardban.Find(M.key) || hardban.Find(M.ckey) || hardban.Find(M.client))
				crban_fullban(M, "Autoban", "Autobanner")

/datum/game_mode/proc/check_win()
	var/list/L = list(  )

	var/area/A = locate(/area/shuttle)

	for(var/mob/M in world)
		if (M.client)
			if (M.stat != 2)
				var/T = M.loc
				var/s = 0
				for (var/area/B in A.superarea.areas) //Altered to support multiple areas
					if ((T in B))
						L[text("[]", M.rname)] = "shuttle"
						s = 1
						break
				if (!s)
					if (istype(T, /obj/machinery/vehicle/pod))
						L[text("[]", M.rname)] = "pod"
					else
						L[text("[]", M.rname)] = "alive"

	if (L.len)
		world << "\blue <B>The game has ended!</B>"
		for(var/I in L)
			var/tem = L[text("[]", I)]
			switch(tem)
				if("shuttle")
					world << text("\t <B><FONT size = 2>[] has left on the shuttle!</FONT></B>", I)
				if("pod")
					world << text("\t <FONT size = 2>[] has fled on an escape pod!</FONT>", I)
				if("alive")
					world << text("\t <FONT size = 1>[] decided to stay on the station.</FONT>", I)
	else
		world << "\blue <B>No one lived!</B>"
	return 1

/datum/game_mode/proc/randomchems()
	var/obj/item/weapon/chem/random1
	var/obj/item/weapon/chem/random2
	var/obj/item/weapon/chem/random3
	var/obj/item/weapon/chem/random4
	var/deux
	var/tres
	var/quatre
//	restart
	random1 = pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury", "lithium", "radium", "silicon")
	random2 = pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury", "lithium", "radium", "silicon")
	random3 = pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury", "lithium", "radium", "silicon")
	random4 = pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury", "lithium", "radium", "silicon")
	deux = pick(34 ; random2, "potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury", "lithium", "radium", "silicon")
	tres = pick(34 ; random3, "potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury", "lithium", "radium", "silicon")
	quatre = pick(34 ; random4, "potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury", "lithium", "radium", "silicon")

//	if (deux == tres || deux == quatre || tres == quatre)
//		goto restart

	for (var/obj/item/weapon/chem/beaker/B in world)
		B:random1 = random1
		B:random2 = random2
		B:random3 = random3
		B:random4 = random4

	for (var/obj/item/weapon/paper/alchemy/C in world)
		C.info = {" <B>Chemistry Information</B>

<B>Note:</B> Centcom reports on the strange results of combining the following chemicals:<BR>

[random1]
[deux]
[tres]
[quatre]

Further investigation and testing is warranted.
"}


