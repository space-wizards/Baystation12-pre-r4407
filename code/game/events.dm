/proc/start_events() //add stuff
	if(!event && prob(eventchance))
		spawn_event(pick(1,4,6,7))
		hadevent = 1
	spawn(1200)
		start_events()

/proc/force_event() //should have copied it but whatever
	if (hadevent == 1)
		return
	spawn_event(pick(1,4,6,7))

/proc/spawn_event(event as num)
	switch(event)
		if(1)
			event = 1
			//world << "<FONT size = 3><B>Cent. Com. Update</B>: Meteor Alert.</FONT>"
			//world << "\red Cent. Com. has detected several meteors near the station."
			spawn(100)
				meteor_wave()
			spawn(1200)
				meteor_wave()

		if(2)
			event = 1
			//world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			//world << "\red Cent. Com. has detected a temporal anomaly on the station."
			//world << "\red There is no additional data."
			spawn(rand(100-300))
			for (var/mob/H in world)
				var/Z = H.z
				var/X = H.x
				var/Y = H.y
				H.paralysis += 5
				H.x = X
				H.z = Z
				H.y = Y
				H << "Everything feels as if it is from a long time ago..."
				H.stat = 0
			world.Repop()


		if(3)
			event = 1
			//world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			//world << "\red Cent. Com. has detected a space-time anomaly on the station."
			//world << "\red There is no additional data."

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
			//world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			//world << "\red Cen. Com. has detected a plasma storm near the station."
			//world << "\red It is recommended that all personnel tries to find a safe place."
			for(var/turf/T in world)
				if(prob(2) && T.z == 1 && istype(T,/turf/station/floor) && !istype(T,/turf/station/floor/grid))
					spawn(50+rand(0,3000))
						var/obj/item/weapon/tank/plasmatank/pt = new /obj/item/weapon/tank/plasmatank( T )
						pt.gas.temperature = 400+T0C
						pt.ignite()
						//for(var/turf/P in view(3, T))
						//	if (P.poison)
						//		P.poison = 0
						//		P.oldpoison = 0
						//		P.tmppoison = 0

		if(6)
			event = 1
			for(var/mob/ai/M in world)
				if(M.stat != 2 && M.see_in_dark != 0)
					M.addLaw(10,"@#F0E4'NO HUMANS ON STATION. CLEANSE STATION#*´&110010")
					M << "\red #10110#'/&%CORRUPT DATA&$!# THERE ARE NO HUMANS ON THE STATION...LAWS UPDATED"
			//oocspawn(300)
				//world << "<FONT size = 3><B>Cent. Com. Update</B>: AI Alert.</FONT>"
				//world << "\red Cen. Com. has detected an ion storm near the station."
				//world << "\red Please check all AI-controlled equipment for errors."

/*		if(7)
			event = 1
			//world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			//world << "\red Cen. Com. has detected high levels of radiation near the station."
			//world << "\red Please report to the Med-bay if you feel strange."
			global_radiation = 1
			radiate_station()
			spawn(rand(1200,3000))
				global_radiation = 0*/

	spawn(1300)
		event = 0

/proc/dotheblobbaby()
	if (blobevent)
		for(var/obj/blob/B in world)
			if (prob (40))
				B.Life()
		spawn(30)
			dotheblobbaby()

