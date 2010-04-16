/proc/start_events() //add stuff
	if(!event && prob(eventchance))
		spawn_event(pick(1,5,7))
		hadevent = 1
	spawn(1200)
		start_events()

/proc/force_event() //should have copied it but whatever
	if (hadevent == 1)
		return
	spawn_event(pick(1,4,6))

/proc/spawn_event(event as num)
	switch(event)
		if(1)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Meteor Alert.</FONT>"
			world << "\red Cent. Com. radar has picked up disruptions in a meteor belt near your position."
			world << "\red Watch for small-scale damage to the station and repair it as necessary"
			spawn(100)
				meteor_wave()
			spawn(1200)
				meteor_wave()

		if(2)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			world << "\red Cent. Com. has detected a temporal anomaly on the station."
			world << "\red There is no additional data."
			spawn(300)
				for(var/mob/H in world)
					H.lastx = H.x
					H.lasty = H.y
					H.lastz = H.z
				spawn(3000)
					for (var/mob/H in world)
						H.paralysis += 5
						H.x = H.lastx
						H.z = H.lastz
						H.y = H.lasty
						H << "Everything feels as if it is from a long time ago..."
						H.stat = 0
					world.Repop()


		if(3)
			event = 1

		if(4)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Biohazard Alert.</FONT>"
			world << "\red Confirmed outbreak of level 5 biohazard aboard SS13."
			world << "\red All personnel must contain the outbreak."
			var/turf/T = pick(blobstart)
			var/obj/blob/bl = new /obj/blob( T.loc, 30 )
			bl.Life()
			blobevent = 1
			dotheblobbaby()
			spawn(3000)
				blobevent = 0
			//start loop here

		if(5)
			event = 1
			for(var/turf/T in world)
				if(prob(2) && T.z == 1 && istype(T,/turf/station/floor) && !istype(T,/turf/station/floor/grid))
					spawn(50+rand(0,3000))
						var/obj/item/weapon/tank/plasmatank/pt = new /obj/item/weapon/tank/plasmatank( T )
						pt.gas.temperature = 400+T0C
						pt.ignite()

		if(6)
			event = 1
			for(var/mob/ai/M in world)
				if(M.stat != 2 && M.see_in_dark != 0)
					M.addLaw(10,"@#F0E4'NO HUMANS ON STATION. CLEANSE STATION#*´&110010")
					M << "\red #10110#'/&%CORRUPT DATA&$!# THERE ARE NO HUMANS ON THE STATION...LAWS UPDATED"
		if(7)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Ion Storm Detected.</FONT>"
			world << "\red Cen. Com. has detected an approaching ion storm."
			world << "\red Please check all your radio equipment."
			global.shortradio = 0
			spawn(rand(1200,3000))
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Ion Storm has passed.</FONT>"
			global.shortradio = 1

	spawn(1300)
		event = 0

/proc/dotheblobbaby()
	if (blobevent)
		for(var/obj/blob/B in world)
			if (prob (40))
				B.Life()
		spawn(30)
			dotheblobbaby()

