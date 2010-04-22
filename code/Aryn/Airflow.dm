var
	AF_MOVEMENT_THRESHOLD = 10000
	AF_DAMAGE_MULTIPLIER = 100
	AF_STUN_MULTIPLIER = 1

proc/Airflow(zone/A,zone/B,n)
	if(n < 0) return
	var/list/connected_turfs = A.connections[B]
	var/list/pplz = A.movables()
	var/list/otherpplz = B.movables()
	if(abs(n) > AF_MOVEMENT_THRESHOLD)
		//world << "SWASH!"
		for(var/atom/movable/M in otherpplz)
			//world << "[M] / \..."
			if(M.anchored && !ismob(M)) continue
			if(istype(M,/mob/ai)) continue
			var/fail = 1
			for(var/turf/U in connected_turfs)
				if(M in range(U)) fail = 0
			if(fail) continue
			//world << "Sonovabitch! [M] won't move!"
			if(!M.airflow_dest)
				M.airflow_dest = pick(connected_turfs)
				spawn M.GotoAirflowDest(abs(n) / AF_MOVEMENT_THRESHOLD)
			else
				M.airflow_speed = abs(n) / AF_MOVEMENT_THRESHOLD
		for(var/atom/movable/M in pplz)
			//world << "[M] / \..."
			if(istype(M,/mob/ai)) continue
			if(M.anchored && !ismob(M)) continue
			var/fail = 1
			for(var/turf/U in connected_turfs)
				if(M in range(U)) fail = 0
			if(fail) continue
			//world << "Sonovabitch! [M] won't move either!"
			if(!M.airflow_dest)
				M.airflow_dest = pick(connected_turfs)
				spawn M.RepelAirflowDest(abs(n) / 10000)
			else
				M.airflow_speed = abs(n) / 10000
atom/movable
	var/turf/airflow_dest
	var/airflow_speed = 0
	proc/GotoAirflowDest(n)
		airflow_speed = n
		var
			xo = src.x - airflow_dest.x
			yo = src.x - airflow_dest.y
		airflow_dest = null
		while(airflow_dest && airflow_speed > 0)
			airflow_speed = min(airflow_speed,9)
			sleep(10-airflow_speed)
			if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
				src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
			if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
				return
			step_towards(src, src.airflow_dest)
		airflow_dest = null
	proc/RepelAirflowDest(n)
		airflow_speed = n
		var
			xo = -(src.x - airflow_dest.x)
			yo = -(src.x - airflow_dest.y)
		airflow_dest = null
		while(airflow_dest && airflow_speed > 0)
			airflow_speed = min(airflow_speed,9)
			sleep(10-airflow_speed)
			if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
				src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
			if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
				return
			step_towards(src, src.airflow_dest)
		airflow_dest = null
	Bump(atom/A)
		. = ..()
		if(airflow_speed && airflow_dest)
			if(ismob(src) && !istype(src,/mob/ai))
				var/b_loss = airflow_speed * AF_DAMAGE_MULTIPLIER
				for(var/organ in src:organs)
					var/obj/item/weapon/organ/external/temp = src:organs[text("[]", organ)]
					if (istype(temp, /obj/item/weapon/organ/external))
						switch(temp.name)
							if("head")
								temp.take_damage(b_loss * 0.2, 0)
							if("chest")
								temp.take_damage(b_loss * 0.4, 0)
							if("diaper")
								temp.take_damage(b_loss * 0.1, 0)
							if("l_arm")
								temp.take_damage(b_loss * 0.05, 0)
							if("r_arm")
								temp.take_damage(b_loss * 0.05, 0)
							if("l_hand")
								temp.take_damage(b_loss * 0.0225, 0)
							if("r_hand")
								temp.take_damage(b_loss * 0.0225, 0)
							if("l_leg")
								temp.take_damage(b_loss * 0.05, 0)
							if("r_leg")
								temp.take_damage(b_loss * 0.05, 0)
							if("l_foot")
								temp.take_damage(b_loss * 0.0225, 0)
							if("r_foot")
								temp.take_damage(b_loss * 0.0225, 0)
				src:UpdateDamageIcon()
				if(airflow_speed > 5)
					src:paralysis += airflow_speed*AF_STUN_MULTIPLIER
					src:stunned = max(src:stunned,src:paralysis + 3)
				else
					src:stunned += airflow_speed * AF_STUN_MULTIPLIER/2
			airflow_speed = 0
			airflow_dest = null

zone/proc/movables()
	. = list()
	for(var/turf/T in contents)
		for(var/atom/A in T)
			. += A

obj/machinery/door/is_door = 1
obj/machinery/door/poddoor/is_door = 1