var nextSolarID = 0
/obj/machinery/power/solar_control/New()
	..()
	spawn(15)
		while(building)
			sleep(10)
		if(!id)
			sleep(5)
			id=nextSolarID+1
		if(isnum(id) && id>nextSolarID)nextSolarID=id
		spawn(0)
			while(!powernet)
				sleep(1)
			for(var/obj/machinery/power/solar/S in powernet.nodes)
				if(!S.id) S.id=id
				if(S.id != id) continue
				cdir = S.adir
				updateicon()

/obj/machinery/power/solar_control/attackby(obj/item/weapon/W, mob/user)
	if(building)
		if(istype(W,/obj/item/weapon/circuitry)&&building<4)
			building++
			updateicon()
			del(W)
			return
		if(istype(W,/obj/item/weapon/cable_coil)&&building==4)
			var/obj/item/weapon/cable_coil/C=W
			if(!C.use(4))
				user<<"Need more"
				return
			building++
			updateicon()
			return
		if(istype(W,/obj/item/weapon/sheet/glass)&&building==5)
			var/obj/item/weapon/sheet/glass/G=W
			if(G.amount<4)
				user<<"Need more"
				return
			G.amount-=4
			if(G.amount==0)
				del(G)
			building=0
			updateicon()
			density=1
			id=""
			del(W)
			return
	..()

/obj/machinery/power/solar_control/updateicon()
	if(building)
		icon_state="solar_con_build[building]"
		return
	if(stat & BROKEN)
		icon_state = "broken"
		overlays = null
		return
	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		overlays = null
		return

	icon_state = "solar_con"
	overlays = null
	if(cdir > 0)
		overlays += image('enginecomputer.dmi', "solcon-o", FLY_LAYER, cdir)
	return

/obj/machinery/power/solar_control/attack_ai(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN | NOPOWER) || building) return

	interact(user)

/obj/machinery/power/solar_control/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN | NOPOWER) || building) return

	interact(user)

/obj/machinery/power/solar_control/process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN) || building)
		return

	use_power(250)
	if(track && nexttime < world.timeofday && trackrate)
		nexttime = world.timeofday + 3600/abs(trackrate)
		cdir = (cdir+trackrate/abs(trackrate)+360)%360

		set_panels(cdir)
		updateicon()

	src.updateDialog()

/obj/machinery/power/solar_control/proc/interact(mob/user)
	if(stat & (BROKEN | NOPOWER) || building) return
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/ai))
			user.machine = null
			user << browse(null, "window=solcon")
			return

	add_fingerprint(user)
	user.machine = src

	var/t = "<TT><B>Solar Generator Control</B><HR><PRE>"
	t += "Generated power : [round(lastgen)] W<BR><BR>"
	t += "<B>Orientation</B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR><BR><BR>"

	t += "<BR><HR><BR><BR>"

	t += "Tracking: [ track ? "<B>On</B> <A href='?src=\ref[src];track=0'>Off</A>" : "<A href='?src=\ref[src];track=1'>On</A> <B>Off</B>"]<BR>"
	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",5,30,180)]<BR><BR>"
	t += "<A href='?src=\ref[src];close=1'>Close</A></TT>"
	user << browse(t, "window=solcon")
	return

/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.machine = null
		return
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.machine = null
		return

	if(href_list["dir"])
		cdir = text2num(href_list["dir"])
		spawn(1)
			set_panels(cdir)
			updateicon()

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = dd_range(0,359,(360+src.cdir+text2num(href_list["cdir"]))%360)
			spawn(1)
				set_panels(cdir)
				updateicon()
		if(href_list["tdir"])
			src.trackrate = dd_range(-7200,7200,src.trackrate+text2num(href_list["tdir"]))
			if(src.trackrate) nexttime = world.timeofday + 3600/abs(trackrate)

	if(href_list["track"])
		if(src.trackrate) nexttime = world.timeofday + 3600/abs(trackrate)
		track = !track

	src.updateUsrDialog()
	return

/obj/machinery/power/solar_control/proc/set_panels(var/cdir)
	if(!powernet || building) return
	for(var/obj/machinery/power/solar/S in powernet.nodes)
		if(!S.id)S.id=id
		if(S.id != id) continue
		S.control = src
		S.ndir = cdir

/obj/machinery/power/solar_control/power_change()
	if(powered())
		stat &= ~NOPOWER
		updateicon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			updateicon()

/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	updateicon()

/obj/machinery/power/solar_control/meteorhit()
	broken()
	return

/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return

/obj/machinery/power/solar_control/blob_act()
	if (prob(50))
		broken()
		src.density = 0

