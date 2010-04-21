/obj/machinery/computer/comcontrol
	name = "Communication Control"
	icon_state = "comm"
	var/cdir = 0
	var/obj/machinery/computer/comdisc/relay = null

/obj/machinery/computer/comcontrol/New()
	..()
	if(!relay)
		var/obj/machinery/computer/comdisc/wep
		var/list/whoop
		for(wep in world)
			if(!wep.gotcomp)
				whoop += wep
		relay = pick(whoop)
		relay.gotcomp = 1

/obj/machinery/computer/comdisc
	name = "Long Range Communication Relay"
	icon = 'power.dmi'
	icon_state = "sp_base"
	var/angle = 90
	var/connected = 0
	var/gotcomp = 0
	var/context = "null"
	var/control = 0

/obj/machinery/computer/comcontrol/attack_ai(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	if(buildstate < 6)
		return
	attack_hand(user)

/obj/machinery/computer/comcontrol/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	if(buildstate < 6)
		return
	interact(user)

/obj/machinery/computer/comcontrol/proc/interact(mob/user)
	if(stat & (BROKEN | NOPOWER)) return
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/ai))
			user.machine = null
			user << browse(null, "window=comcon")
			return

	add_fingerprint(user)
	user.machine = src
	var/dis = ""
	if(relay.connected)
		dis = "Connected"
	else
		dis = "NO SIGNAL"
	var/t = "<TT><B>Dish Relay Control</B><HR><PRE>"
	t += "<B>Connection Status<B>:[dis]<BR><BR>"
	t += "<B>Orientation</B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR><BR><BR>"
	t += "<B><BR><BR><BR>"
	user << browse(t, "window=comcon")
	return

/obj/machinery/computer/comcontrol/Topic(href, href_list)
	if(href_list["close"] )
		usr << browse(null,"window=comcon")
		return
	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = dd_range(0,359,(360+src.cdir+text2num(href_list["cdir"]))%360)
			spawn(1)
				relay.set_panels(cdir)
	src.updateUsrDialog()
	return
/obj/machinery/computer/comdisc/proc/set_panels(var/cdir)
	ndir = cdir
	updateicon()
	process()

/* DISC RELAY */

/obj/machinery/computer/comdisc/New()
	..()
	updateicon()

/obj/machinery/computer/comcontrol/updateicon()
/obj/machinery/computer/comdisc/attackby(obj/item/weapon/W, mob/user)
	..()
	if(istype(W,/obj/item/weapon/sheet/glass))
		var/obj/item/weapon/sheet/glass/S = W
		if(buildstate == 1)
			if(S.amount >= 2)
				S.amount -= 2
			else
				del S
			buildstate++
			user << "Need more glass"
		else if(buildstate == 2)
			if(S.amount >= 2)
				S.amount--
			else
				del S
			buildstate++
			user << "dont need more."
	if(istype(W, /obj/item/weapon/circuitry))
		if(buildstate == 3)
			del W
			buildstate = 6
			user << "done"
	src.add_fingerprint(user)
	src.health -= W.force
	src.healthcheck()
	src.updateicon()
	return

/obj/machinery/computer/comdisc/blob_act()
	src.health--
	src.healthcheck()
	return

/obj/machinery/computer/comdisc/proc/healthcheck()
	if (src.health <= 0)
		if(!(stat & BROKEN))
			broken()
		else
			new /obj/item/weapon/shard(src.loc)
			new /obj/item/weapon/shard(src.loc)
			del(src)
			return
	return

/obj/machinery/computer/comdisc/updateicon()
	overlays = null
	if(buildstate < 6)
		return
	if(stat & BROKEN)
		overlays += image('power.dmi', icon_state = "solar_panel-b", layer = FLY_LAYER)
	else
		overlays += image('power.dmi', icon_state = "solar_panel", layer = FLY_LAYER)
		src.dir = angle2dir(ndir)
	return

/obj/machinery/computer/comdisc/power_change()
	return

/obj/machinery/computer/comdisc/process()
	if(stat & BROKEN)
		longradio = 0
		connected = 0
		return
	var/X = home
	var/Y = home
	X -= 20
	Y += 20
	if(ndir <= Y)
		if(ndir >= X)
			connected = 1
			longradio = 1
		else
			connected = 0
			longradio = 0
	else if(ndir >= X)
		if(ndir <= Y)
			connected = 1
			longradio = 1
		else
			connected = 0
			longradio = 0
	else
		connected = 0
		longradio = 0

/obj/machinery/computer/comdisc/proc/broken()
	stat |= BROKEN
	updateicon()
	return

/obj/machinery/computer/comdisc/meteorhit()
	if(stat & !BROKEN)
		broken()
	else
		del(src)

/obj/machinery/computer/comdisc/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			if(prob(15))
				new /obj/item/weapon/shard( src.loc )
			return
		if(2.0)
			if (prob(50))
				broken()
				buildstate = 1
		if(3.0)
			if (prob(25))
				broken()
				buildstate = 1
	return

