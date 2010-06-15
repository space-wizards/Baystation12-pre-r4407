/obj/machinery/turret
	name = "turret"
	icon = 'weap_sat.dmi'
	icon_state = "grey_target_prism_new"
	var/raised = 0
	var/enabled = 1
	anchored = 1
	layer = 3
	invisibility = 2
	density = 1
	var/lasers = 0
	var/health = 18
	var/obj/machinery/turretcover/cover = null
	var/popping = 0
	var/wasvalid = 0
	var/lastfired = 0
	var/shot_delay = 30 //3 seconds between shots
	var/floor = 0
	var/ads = 0
	var/staypop = 0

/obj/machinery/turretcover
	name = "pop-up turret cover"
	icon = 'weap_sat.dmi'
	icon_state = "turretCover"
	anchored = 1
	layer = 3.5
	density = 0
	var/floor = 0

/obj/machinery/turret/proc/isPopping()
	return (popping!=0)

/obj/machinery/turret/power_change()
	if(stat & BROKEN)
		icon_state = "grey_target_prism_new"
	else
		if( powered() )
			if (src.enabled)
				if (src.lasers)
					icon_state = "orange_target_prism_new"
				else
					icon_state = "target_prism_new"
			else
				icon_state = "grey_target_prism_new"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "grey_target_prism_new"
				stat |= NOPOWER

/obj/machinery/turret/proc/setState(var/enabled, var/lethal)
	src.enabled = enabled
	src.lasers = lethal

	src.power_change()

/obj/machinery/turret/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(lastfired && world.time - lastfired < shot_delay)
		return
	lastfired = world.time
	if (src.cover==null)
		src.cover = new /obj/machinery/turretcover(src.loc)
	if (src.staypop || src.ads)
		if (!isPopping())
			if (isDown())
				popUp()
	use_power(50)
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		world << text("Badly positioned turret - loc.loc is [].", loc)
		return
	var/area/area = loc
	if (istype(area, /area))
		if (istype(loc, /area/turret_protected) || istype(loc, /area/auto_protected))
			src.wasvalid = 1
			var/area/turret_protected/tarea = loc

			if (tarea.turretTargets.len>0)
				if (!isPopping())
					if (isDown())
						popUp()
					if (!src.enabled)
						if (!isDown())
							popDown()
					else
						var/mob/target = pick(tarea.turretTargets)
						if (src.dir != get_dir(src,target))
							var/QQ = pick(1,2)
							src.hear_sound("sound/weapon/turret/move[QQ].wav",3)
						src.dir = get_dir(src, target)
						if (src.enabled)
							if (target.stat!=2)
								src.shootAt(target)
							else
								tarea.subjectDied(target)

		else
			if (src.wasvalid)
				src.die()
			else
				world << text("ERROR: Turret at [], [], [] is NOT in a turret-protected area!", x, y, z)

/obj/machinery/turret/proc/isDown()
	return (invisibility!=0)

/obj/machinery/turret/proc/popUp()
	if ((!isPopping()) || src.popping==-1)
		invisibility = 0
		popping = 1
		if (src.cover!=null)
			flick("popup", src.cover)
			src.cover.icon_state = "openTurretCover"
		spawn(10)
			if (popping==1)
				popping = 0

/obj/machinery/turret/proc/popDown()
	if ((!isPopping()) || src.popping==1)
		popping = -1
		if (src.cover!=null)
			flick("popdown", src.cover)
			src.cover.icon_state = "turretCover"
		spawn(10)
			if (popping==-1)
				invisibility = 2
				popping = 0

/obj/machinery/turret/proc/shootAt(var/mob/target)
	var/turf/T = loc
	var/atom/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return

	var/obj/beam/a_laser/A
	if (src.lasers)
		src.hear_sound("sound/weapon/laser/fire.wav",10)
		A = new /obj/beam/a_laser( loc )
		use_power(50)
	else
		src.hear_sound("sound/weapon/taser/fire.wav",8)
		A = new /obj/bullet/electrode( loc )
		use_power(100)

	if (!( istype(U, /turf) ))
		//A = null
		del(A)
		return
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 0 )
		A.process()
		return
	return

/obj/machinery/turret/las_act(flag)
	if (flag == "bullet")
		src.health -= 3
	if (flag) //taser
		src.health -= 1
	else
		src.health -= 2

	if (src.health <= 0)
		src.die()
	return


/obj/machinery/turret/ex_act(severity)
	if(severity < 3)
		src.die()

/obj/machinery/turret/proc/die()
	src.health = 0
	src.density = 0
	src.stat |= BROKEN
	src.icon_state = "destroyed_target_prism_new"
	if (cover!=null)
		del(cover)
	sleep(3)
	flick("explosion", src)
	spawn(13)
		del(src)
