/obj/machinery/door/poddoor/open()
	usr << "This is a remote controlled door!"
	return

/obj/machinery/door/poddoor/close()
	usr << "This is a remote controlled door!"
	return

/obj/machinery/door/poddoor/attackby(obj/item/weapon/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (!( istype(C, /obj/item/weapon/crowbar) ))
		return
	if ((src.density && (stat & NOPOWER) && !( src.operating )))
		spawn( 0 )
			src.operating = 1
			flick("pdoorc0", src)
			src.icon_state = "pdoor0"
			sleep(15)
			src.density = 0
			sd_SetOpacity(0)
			var/turf/T = src.loc
			if (istype(T, /turf) && checkForMultipleDoors())
				T.updatecell = 1
				OpenDoor(src)
			src.operating = 0
			return
	return

/obj/machinery/door/poddoor/Bumped(atom/movable/AM as mob|obj)
	return

/obj/machinery/door/poddoor/proc/openpod()
	set src in oview(1)

	if(stat & (NOPOWER|BROKEN))
		return

	if (src.operating || !src.density)
		return
	src.operating = 1
	use_power(50)
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	sleep(15)
	src.density = 0
	sd_SetOpacity(0)
	var/turf/T = src.loc
	if (istype(T, /turf) && checkForMultipleDoors())
		T.updatecell = 1
		OpenDoor(src)
	src.operating = 0
	return

/obj/machinery/door/poddoor/proc/closepod()
	set src in oview(1)

	if(stat & (NOPOWER|BROKEN))
		return

	if (src.operating || src.density)
		return
	use_power(50)
	src.operating = 1
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"
	src.density = 1
	sd_SetOpacity(1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.updatecell = 0
		CloseDoor(src)
	sleep(15)
	src.operating = 0
	return

/obj/machinery/door/poddoor/receivemessage(message,sender)
	if(..())
		return 1
	var/command = uppertext(stripnetworkmessage(message))
	//world << "DOOR REC [command]"
	var/listofcommand = dd_text2list(command," ",null)
	if(listofcommand < 2)
		return
	if(check_password(listofcommand[1]))
		if(listofcommand[2] == "OPEN")
			spawn(0)
				openpod()
		else if(listofcommand[2] == "CLOSE")
			spawn(0)
				closepod()
	return 0

///////////////////////
//Stationwide shields//
///////////////////////

/obj/machinery/door/barrier/process()
	if(!(stat & NOPOWER))
		var/energy = ((rating^3)*0.75)+500			// holy fucking shit
		use_power(energy,EQUIP)