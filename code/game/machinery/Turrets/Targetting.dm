/area/auto_protected
	name = "Meteor Defense Area"
	var/list/turretTargets = list()

/area/turret_protected
	name = "Turret Protected Area"
	var/list/turretTargets = list()

/area/turret_protected/proc/subjectDied(var/mob/target)
	if (istype(target, /mob))
		if (!istype(target, /mob/ai))
			if (target:stat==2)
				if (target in turretTargets)
					src.Exited(target)

/area/turret_protected/Entered(atom/movable/O)
	..()
	if (istype(O, /mob))
		if (!istype(O, /mob/ai))
			for (var/obj/machinery/turretid/H in src)
				if (!H.enabled)
					return
			if (!(O in turretTargets))
				turretTargets += O
	return 1

/area/turret_protected/Exited(atom/movable/O)
	if (istype(O, /mob))
		if (!istype(O, /mob/ai))
			if (O in turretTargets)
				turretTargets -= O
			if (turretTargets.len == 0)
				popDownTurrets()

	return 1

/area/turret_protected/proc/popDownTurrets()
	for (var/obj/machinery/turret/aTurret in src)
		aTurret.popDown()
