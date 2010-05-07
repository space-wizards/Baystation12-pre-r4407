/obj/item/weapon/flamethrower
	name = "flamethrower"
	icon_state = "flamethrower"
	s_istate = "flamethrower_0"
	desc = "You are a firestarter!"
	flags = 322.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	var/processing = 0
	var/operating = 0
	var/obj/item/weapon/tank/plasmatank/attached = null
	var/throw_amount = 100
	var/lit = 0	//on or off
	var/turf/previousturf = null

/obj/item/weapon/flamethrower/proc/process()
	if(src.processing) //already doing this
		return
	src.processing = 1

	while(src.lit)
		var/turf/location = src.loc
		if(istype(location, /mob/))
			var/mob/M = location
			if(M.l_hand == src || M.r_hand == src)
				location = M.loc

		if(isturf(location)) //start a fire if possible
			location.firelevel = max(location.firelevel, location.poison + 1)

		sleep(10)
	processing = 0	//we're done

/obj/item/weapon/flamethrower/attackby(obj/item/weapon/tank/plasmatank/W as obj, mob/user as mob)
	if(user.stat || user.restrained() || user.lying)
		return
	if (istype(W,/obj/item/weapon/tank/plasmatank))
		if(attached)
			user << "\red There appears to already be a plasma tank loaded in the flamethrower!"
			return
		attached = W
		W.loc = src
		if (user.client)
			user.client.screen -= W
		user.u_equip(W)
		lit = 0
		force = 3
		damtype = "brute"
		icon_state = "flamethrower_loaded_0"
		s_istate = "flamethrower_0"
	else if (istype(W, /obj/item/weapon/analyzer) && get_dist(user, src) <= 1 && attached)
		var/obj/item/weapon/icon = src
		for (var/mob/O in viewers(user, null))
			O << "\red [user] has used the analyzer on \icon[icon]"
			var/total = src.attached.gas.tot_gas()
			var/t1 = 0
			user << "\blue Results of analysis of \icon[icon]"
			if (total)
				user << "\blue Overall: [total] / [src.attached.maximum]"
				t1 = round( src.attached.gas.n2 / total * 100 , 0.0010)
				user << "\blue Nitrogen: [t1]%"
				t1 = round( src.attached.gas.oxygen / total * 100 , 0.0010)
				user << "\blue Oxygen: [t1]%"
				t1 = round( src.attached.gas.plasma / total * 100 , 0.0010)
				user << "\blue Plasma: [t1]%"
				t1 = round( src.attached.gas.co2 / total * 100 , 0.0010)
				user << "\blue CO2: [t1]%"
				t1 = round( src.attached.gas.sl_gas / total * 100 , 0.0010)
				user << "\blue N2O: [t1]%"
				user << text("\blue Temperature: []&deg;C", src.attached.gas.temperature-T0C)
			else
				user << "\blue Tank is empty!"
	else	return	..()
	return

/obj/item/weapon/flamethrower/Topic(href,href_list[])
	if (href_list["close"])
		usr.machine = null
		usr << browse(null, "window=flamethrower")
		return
	if(usr.stat || usr.restrained() || usr.lying)
		return
	usr.machine = src
	if (href_list["light"])
		if(!attached)	return
		if(attached.gas.plasma < 1)	return
		lit = !(lit)
		if(lit)
			icon_state = "flamethrower_loaded_1"
			s_istate = "flamethrower_1"
			force = 17
			damtype = "fire"
			spawn(0)
				src.process()
		else
			icon_state = "flamethrower_loaded_0"
			s_istate = "flamethrower_0"
			force = 3
			damtype = "brute"
	if (href_list["amount"])
		src.throw_amount = src.throw_amount + text2num(href_list["amount"])
		src.throw_amount = max(50,min(5000,src.throw_amount))
	if (href_list["remove"])
		if(!attached)	return
		var/obj/item/weapon/tank/plasmatank/A = attached
		A.loc = get_turf(src)
		A.layer = initial(A.layer)
		attached = null
		lit = 0
		force = 3
		damtype = "brute"
		icon_state = "flamethrower"
		s_istate = "flamethrower_0"
		usr.machine = null
		usr << browse(null, "window=flamethrower")
	for(var/mob/M in viewers(1, src.loc))
		if ((M.client && M.machine == src))
			src.attack_self(M)
	return


/obj/item/weapon/flamethrower/attack_self(mob/user as mob)
	if(user.stat || user.restrained() || user.lying)
		return
	user.machine = src
	if (!src.attached)
		user << "\red Attach a plasma tank first!"
		return
	var/dat = text("<TT><B>Flamethrower (<A HREF='?src=\ref[src];light=1'>[lit ? "<font color='red'>Lit</font>" : "Unlit"]</a>)</B><BR>\nAmount in tank / Capacity of tank: [src.attached.gas.tot_gas()] / [src.attached.maximum]<BR>\nAmount to throw: <A HREF='?src=\ref[src];amount=-100'>-</A> <A HREF='?src=\ref[src];amount=-10'>-</A> <A HREF='?src=\ref[src];amount=-1'>-</A> [src.throw_amount] <A HREF='?src=\ref[src];amount=1'>+</A> <A HREF='?src=\ref[src];amount=10'>+</A> <A HREF='?src=\ref[src];amount=100'>+</A><BR>\n<A HREF='?src=\ref[src];remove=1'>Remove plasmatank</A> - <A HREF='?src=\ref[src];close=1'>Close</A></TT>")
	user << browse(dat, "window=flamethrower;size=600x300")
	return


// gets this from turf.dm turf/dblclick
/obj/item/weapon/flamethrower/proc/flame_turf(turflist)
	if(!lit || operating)	return
	operating = 1
	for(var/turf/T in turflist)
		if(T.density || istype(T, /turf/space))
			break
		if(!previousturf && length(turflist)>1)
			previousturf = get_turf(src)
			continue	//so we don't burn the tile we be standin on
		if(previousturf && LinkBlocked(previousturf, T))
			break
		torch_turf(T)
		sleep(1)
	previousturf = null
	operating = 0
//	for(var/mob/M in viewers(1, src.loc))
	//	if ((M.client && M.machine == src))
		//	src.attack_self(M)
	return

/obj/item/weapon/flamethrower/proc/torch_turf(turf/T as turf)
	if(!src.attached) return
	var/volume = src.attached.gas.tot_gas()
	if(!volume)
		lit = 0
		force = 3
		damtype = "brute"
		s_istate = "flamethrower_0"
		icon_state = "flamethrower_loaded_0"
		return

	var/obj/substance/gas/jet = new()
	jet.set_frac(src.attached.gas, min(volume,src.throw_amount*100))
	src.attached.gas.sub_delta(jet)

	jet.set_frac(src.attached.gas, jet.tot_gas()*10)
	jet.turf_add(T,-1) // add all the gas

	T.firelevel += src.attached.gas.temperature*25
	T.temp_set(src.attached.gas.temperature)
	if(T.poison > 5)	T.icon_state = "burning"
	T.res_vars()
	previousturf = T
	return