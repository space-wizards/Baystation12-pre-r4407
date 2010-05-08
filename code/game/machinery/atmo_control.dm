/obj/machinery/proc/process()
	return

/obj/machinery/proc/gas_flow()
	return

/obj/machinery/proc/orient_pipe(source as obj)
	return

/obj/machinery/proc/cut_pipes()
	return

/obj/machinery/proc/disc_pipe(target as obj)
	return

/obj/machinery/proc/buildnodes()
	return

/obj/machinery/proc/getline()
	if(p_dir)
		return src

/obj/machinery/proc/setline()
	return

/obj/machinery/proc/ispipe()
	return 0

/obj/machinery/proc/next()
	return null

/obj/machinery/proc/get_gas_val(from)
	return null

/obj/machinery/proc/get_gas(from)
	return null

/obj/machinery/meter/New()
	..()
	average = 0
	return

/obj/machinery/meter/receivemessage(message as text, var/obj/machinery/srcmachine)
	if(..())
		return
	var/list/commands = getcommandlist(message)
	if(commands.len < 1)
		return
	if(checkcommand(commands,1,"SENSE"))
		transmitmessage(createmessagetomachine("REPORT FLOW [round(100*abs(average)/6e6, 0.1)] [round(target.pl.gas.temperature,0.1)]", srcmachine))

/obj/machinery/meter/process()
	src.target = locate(/obj/machinery/pipes, src.loc)
	if(!target)
		icon_state = "meterX"
		return
	if(stat & (BROKEN|NOPOWER))
		icon_state = "meter0"
		return

	use_power(5)

	average = 0.5 * average + 0.5 * target.pl.flow

	var/val = min(18, round( 18.99 * ((abs(average) / 2500000)**0.25)) )
	icon_state = "meter[val]"

/obj/machinery/meter/Click()
	if(stat & (NOPOWER|BROKEN))
		return
	if (get_dist(usr, src) <= 3 || istype(usr, /mob/ai))
		if (src.target)
			usr << text("\blue <B>Results:</B>\nMass flow []%\nTemperature [] K", round(100*abs(average)/6e6, 0.1), round(target.pl.gas.temperature,0.1))
		else
			usr << "\blue <B>Results: Connection Error!</B>"
	else
		usr << "\blue <B>You are too far away.</B>"
	return


/obj/machinery/atmoalter/siphs/New()
	..()
	src.gas = new /obj/substance/gas( src )
	src.gas.maximum = src.maximum

	return

/obj/machinery/atmoalter/siphs/receivemessage(message as text, var/obj/machinery/srcmachine)
	if(..())
		return
	var/list/commands = getcommandlist(message)
	if(commands.len < 1)
		return
	if(checkcommand(commands,1,"SENSE"))
		var
			tstatus
			cstatus
		switch(t_status)
			if(4) tstatus = "AUTO"
			if(3) tstatus = "STOP"
			if(2) tstatus = "RELEASE"
			if(1) tstatus = "SIPHON"
			else tstatus = "UNKNOWN"
		switch(c_status)
			if(3) cstatus = "STOP"
			if(2) cstatus = "RELEASE"
			if(1) cstatus = "SIPHON"
			if(0) cstatus = "NOCONNECTOR"
			else cstatus = "UNKNOWN"

		transmitmessage(createmessagetomachine("REPORT [gas.tot_gas()] [gas.maximum] [tstatus] [t_per] [cstatus] [c_per]", srcmachine))
	var/command = uppertext(stripnetworkmessage(message))
	var/list/listofcommand = dd_text2list(command," ",null)
	switch(listofcommand[1])
		if("VALVE")
			switch(listofcommand[2])
				if("SIPHON")
					src.t_status = 1
				if("RELEASE")
					src.t_status = 2
				if("STOP")
					src.t_status = 3
				if("AUTO")
					src.t_status = 4
				if("RATE")
					src.t_per = text2num(listofcommand[3])
			setstate()
		if("PVALVE")
			if(c_status)
				switch(listofcommand[2])
					if("SIPHON")
						src.c_status = 1
					if("RELEASE")
						src.c_status = 2
					if("STOP")
						src.c_status = 3
					if("RATE")
						src.c_per = text2num(listofcommand[3])
				setstate()
		if("LOCK")
			if(alterable)
				alterable = 0
		if("UNLOCK")
			if(!alterable)
				alterable = 1


/obj/machinery/atmoalter/siphs/proc/releaseall()
	src.t_status = 1
	src.t_per = max_valve
	return

/obj/machinery/atmoalter/siphs/proc/reset(valve, auto)
	if(c_status!=0)
		return

	if (valve < 0)
		src.t_per =  -valve
		src.t_status = 1
	else
		if (valve > 0)
			src.t_per = valve
			src.t_status = 2
		else
			src.t_status = 3
	if (auto)
		src.t_status = 4
	src.setstate()
	return

/obj/machinery/atmoalter/siphs/proc/release(amount, flag)

	var/T = src.loc
	if (!( istype(T, /turf) ))
		return
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	if (!( amount ))
		return
	if (!( flag ))
		amount = min(amount, max_valve)
	src.gas.turf_add(T, amount)
	return

/obj/machinery/atmoalter/siphs/proc/siphon(amount, flag)

	var/T = src.loc
	if (!( istype(T, /turf) ))
		return
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	if (!( amount ))
		return
	if (!( flag ))
		amount = min(amount, 900000.0)
	src.gas.turf_take(T, amount)
	return

/obj/machinery/atmoalter/siphs/proc/setstate()

	if(stat & NOPOWER)
		icon_state = "siphon:0"
		return

	if (src.holding)
		src.icon_state = "siphon:T"
	else
		if (src.t_status != 3)
			src.icon_state = "siphon:1"
		else
			src.icon_state = "siphon:0"
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/New()

	..()
	if(!empty)
		if(istype(src,/obj/machinery/atmoalter/siphs/fullairsiphon/halfairsiphon))
			src.gas.oxygen = 1.365E7
			src.gas.n2 = 5.135E7
		else
			src.gas.oxygen = 2.73E7
			src.gas.n2 = 1.027E8
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/port/reset(valve, auto)

	if (valve < 0)
		src.t_per =  -valve
		src.t_status = 1
	else
		if (valve > 0)
			src.t_per = valve
			src.t_status = 2
		else
			src.t_status = 3
	if (auto)
		src.t_status = 4
	src.setstate()
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/air_vent/attackby(W as obj, user as mob)

	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.c_status)
			src.anchored = 1
			src.c_status = 0
		else
			if (locate(/obj/machinery/connector, src.loc))
				src.anchored = 1
				src.c_status = 3
	else
		if (istype(W, /obj/item/weapon/wrench))
			src.alterable = !( src.alterable )
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/air_vent/setstate()


	if(stat & NOPOWER)
		icon_state = "vent-p"
		return

	if (src.t_status == 4)
		src.icon_state = "vent2"
	else
		if (src.t_status == 3)
			src.icon_state = "vent0"
		else
			src.icon_state = "vent1"
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/air_vent/reset(valve, auto)

	if (auto)
		src.t_status = 4
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/halfairsiphon/airlock_vent/attackby(W as obj, user as mob)

	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.c_status)
			src.anchored = 1
			src.c_status = 0
		else
			if (locate(/obj/machinery/connector, src.loc))
				src.anchored = 1
				src.c_status = 3
	else
		if (istype(W, /obj/item/weapon/wrench))
			src.alterable = !( src.alterable )
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/halfairsiphon/airlock_vent/setstate()


	if(stat & NOPOWER)
		icon_state = "wmsiphon:0"
		return

	if (src.t_status == 4)
		src.icon_state = "wmsiphon:1"
	else
		if (src.t_status == 3)
			src.icon_state = "wmsiphon:0"
		else
			src.icon_state = "wmsiphon:1"
	return

/obj/machinery/atmoalter/siphs/fullairsiphon/halfairsiphon/airlock_vent/reset(valve, auto)

	if (auto)
		src.t_status = 4
	return

/obj/machinery/atmoalter/siphs/scrubbers/process()

	if(stat & NOPOWER) return

	if (src.t_status != 3)
		var/turf/T = src.loc
		if (istype(T, /turf))
			if (locate(/obj/move, T))
				T = locate(/obj/move, T)
			if (T.firelevel < 900000.0)
				src.gas.turf_add_all_oxy(T)

		else
			T = null
		switch(src.t_status)
			if(1.0)
				if( !portable() ) use_power(50, ENVIRON)
				if (src.holding)
					var/t1 = src.gas.tot_gas()
					var/t2 = t1
					var/t = src.t_per
					if (src.t_per > t2)
						t = t2
					src.holding.gas.transfer_from(src.gas, t)
				else
					if (T)
						var/t1 = src.gas.tot_gas()
						var/t2 = t1
						var/t = src.t_per
						if (src.t_per > t2)
							t = t2
						src.gas.turf_add(T, t)
			if(2.0)
				if( !portable() ) use_power(50, ENVIRON)
				if (src.holding)
					var/t1 = src.gas.tot_gas()
					var/t2 = src.maximum - t1
					var/t = src.t_per
					if (src.t_per > t2)
						t = t2
					src.gas.transfer_from(src.holding.gas, t)
				else
					if (T)
						var/t1 = src.gas.tot_gas()
						var/t2 = src.maximum - t1
						var/t = src.t_per
						if (t > t2)
							t = t2
						src.gas.turf_take(T, t)
			if(4.0)
				if( !portable() ) use_power(50, ENVIRON)
				if (T)
					if (T.firelevel > 900000.0)
						src.f_time = world.time + 400
					else
						if (world.time > src.f_time)
							src.gas.extract_toxs(T)
							if( !portable() ) use_power(150, ENVIRON)
							var/contain = src.gas.tot_gas()
							if (contain > 1.3E8)
								src.gas.turf_add(T, 1.3E8 - contain)

	src.setstate()
	src.updateDialog()
	return

/obj/machinery/atmoalter/siphs/scrubbers/air_filter/setstate()

	if(stat & NOPOWER)
		icon_state = "vent-p"
		return

	if (src.t_status == 4)
		src.icon_state = "vent2"
	else
		if (src.t_status == 3)
			src.icon_state = "vent0"
		else
			src.icon_state = "vent1"
	return

/obj/machinery/atmoalter/siphs/scrubbers/air_filter/attackby(W as obj, user as mob)

	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.c_status)
			src.anchored = 1
			src.c_status = 0
		else
			if (locate(/obj/machinery/connector, src.loc))
				src.anchored = 1
				src.c_status = 3
	else
		if (istype(W, /obj/item/weapon/wrench))
			src.alterable = !( src.alterable )
	return

/obj/machinery/atmoalter/siphs/scrubbers/air_filter/reset(valve, auto)

	if (auto)
		src.t_status = 4
	src.setstate()
	return

/obj/machinery/atmoalter/siphs/scrubbers/port/setstate()

	if(stat & NOPOWER)
		icon_state = "scrubber:0"
		return

	if (src.holding)
		src.icon_state = "scrubber:T"
	else
		if (src.t_status != 3)
			src.icon_state = "scrubber:1"
		else
			src.icon_state = "scrubber:0"
	return

/obj/machinery/atmoalter/siphs/scrubbers/port/reset(valve, auto)

	if (valve < 0)
		src.t_per =  -valve
		src.t_status = 1
	else
		if (valve > 0)
			src.t_per = valve
			src.t_status = 2
		else
			src.t_status = 3
	if (auto)
		src.t_status = 4
	src.setstate()
	return

//true if the siphon is portable (therfore no power needed)

/obj/machinery/proc/portable()
	return istype(src, /obj/machinery/atmoalter/siphs/fullairsiphon/port) || istype(src, /obj/machinery/atmoalter/siphs/scrubbers/port)

/obj/machinery/atmoalter/siphs/power_change()

	if( portable() )
		return

	if(!powered(ENVIRON))
		spawn(rand(0,15))
			stat |= NOPOWER
			setstate()
	else
		stat &= ~NOPOWER
		setstate()


/obj/machinery/atmoalter/siphs/process()

//	var/dbg = (suffix=="d") && Debug

	if(stat & (NOPOWER|BROKEN)) return

	if(vsc.plc.CANISTER_CORROSION)
		if(gas.plasma > 10000 && !(flags & PLASMAGUARD))
			if(prob(1))
				stat |= BROKEN
				icon_state = dd_replacetext(icon_state,"0","B")
				icon_state = dd_replacetext(icon_state,"1","B")
				icon_state = dd_replacetext(icon_state,"T","B")
				if(holding)
					holding.Move(loc)
					holding.loc = loc
				gas.turf_add(loc,-1)
				return


	if (src.t_status != 3)
		var/turf/T = src.loc
		if (istype(T, /turf))
			if (locate(/obj/move, T))
				T = locate(/obj/move, T)
		else
			T = null
		switch(src.t_status)
			if(1.0)
				if( !portable() ) use_power(50, ENVIRON)
				if (src.holding)
					var/t1 = src.gas.tot_gas()
					var/t2 = t1
					var/t = src.t_per
					if (src.t_per > t2)
						t = t2
					src.holding.gas.transfer_from(src.gas, t)
				else
					if (T)
						var/t1 = src.gas.tot_gas()
						var/t2 = t1
						var/t = src.t_per
						if (src.t_per > t2)
							t = t2
						src.gas.turf_add(T, t)
			if(2.0)
				if( !portable() ) use_power(50, ENVIRON)
				if (src.holding)
					var/t1 = src.gas.tot_gas()
					var/t2 = src.maximum - t1
					var/t = src.t_per
					if (src.t_per > t2)
						t = t2
					src.gas.transfer_from(src.holding.gas, t)
				else
					if (T)
						var/t1 = src.gas.tot_gas()
						var/t2 = src.maximum - t1
						var/t = src.t_per
						if (t > t2)
							t = t2
						//var/g = gas.tot_gas()
						//if(dbg) world.log << "VP0 : [t] from turf: [gas.tot_gas()]"
						//if(dbg) Air()

						src.gas.turf_take(T, t)
						//if(dbg) world.log << "VP1 : now [gas.tot_gas()]"

						//if(dbg) world.log << "[gas.tot_gas()-g] ([t]) from turf to siph"

						//if(dbg) Air()
			if(4.0)
				if( !portable() )
					use_power(50, ENVIRON)

				if (T)
					if (T.firelevel > 900000.0)
						src.f_time = world.time + 300
					else
						if (world.time > src.f_time)
							var/difference = CELLSTANDARD - (T.oxygen() + T.n2())
							if (difference > 0)
								var/t1 = src.gas.tot_gas()
								if (difference > t1)
									difference = t1
								src.gas.turf_add(T, difference)

	src.updateDialog()

	src.setstate()
	return

/obj/machinery/atmoalter/siphs/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/atmoalter/siphs/attack_paw(user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/atmoalter/siphs/attack_hand(var/mob/user as mob)

	if(stat & NOPOWER) return

	if(src.portable() && istype(user, /mob/ai)) //AI can't use portable siphons
		return

	user.machine = src
	var/tt
	switch(src.t_status)
		if(1.0)
			tt = text("Releasing <A href='?src=\ref[];t=2'>Siphon</A> <A href='?src=\ref[];t=3'>Stop</A>", src, src)
		if(2.0)
			tt = text("<A href='?src=\ref[];t=1'>Release</A> Siphoning <A href='?src=\ref[];t=3'>Stop</A>", src, src)
		if(3.0)
			tt = text("<A href='?src=\ref[];t=1'>Release</A> <A href='?src=\ref[];t=2'>Siphon</A> Stopped <A href='?src=\ref[];t=4'>Automatic</A>", src, src, src)
		else
			tt = "Automatic equalizers are on!"
	var/ct = null
	switch(src.c_status)
		if(1.0)
			ct = text("Releasing <A href='?src=\ref[];c=2'>Accept</A> <A href='?src=\ref[];c=3'>Stop</A>", src, src)
		if(2.0)
			ct = text("<A href='?src=\ref[];c=1'>Release</A> Accepting <A href='?src=\ref[];c=3'>Stop</A>", src, src)
		if(3.0)
			ct = text("<A href='?src=\ref[];c=1'>Release</A> <A href='?src=\ref[];c=2'>Accept</A> Stopped", src, src)
		else
			ct = "Disconnected"
	var/at = null
	if (src.t_status == 4)
		at = text("Automatic On <A href='?src=\ref[];t=3'>Stop</A>", src)
	var/dat = text("<TT><B>Canister Valves</B> []<BR>\n\t<FONT color = 'blue'><B>Contains/Capacity</B> [] / []</FONT><BR>\n\tUpper Valve Status: [] []<BR>\n\t\t<A href='?src=\ref[];tp=-[]'>M</A> <A href='?src=\ref[];tp=-10000'>-</A> <A href='?src=\ref[];tp=-1000'>-</A> <A href='?src=\ref[];tp=-100'>-</A> <A href='?src=\ref[];tp=-1'>-</A> [] <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=100'>+</A> <A href='?src=\ref[];tp=1000'>+</A> <A href='?src=\ref[];tp=10000'>+</A> <A href='?src=\ref[];tp=[]'>M</A><BR>\n\tPipe Valve Status: []<BR>\n\t\t<A href='?src=\ref[];cp=-[]'>M</A> <A href='?src=\ref[];cp=-10000'>-</A> <A href='?src=\ref[];cp=-1000'>-</A> <A href='?src=\ref[];cp=-100'>-</A> <A href='?src=\ref[];cp=-1'>-</A> [] <A href='?src=\ref[];cp=1'>+</A> <A href='?src=\ref[];cp=100'>+</A> <A href='?src=\ref[];cp=1000'>+</A> <A href='?src=\ref[];cp=10000'>+</A> <A href='?src=\ref[];cp=[]'>M</A><BR>\n<BR>\n\n<A href='?src=\ref[];mach_close=siphon'>Close</A><BR>\n\t</TT>", (!( src.alterable ) ? "<B>Valves are locked. Unlock with wrench!</B>" : "You can lock this interface with a wrench."), num2text(src.gas.tot_gas(), 10), num2text(src.maximum, 10), (src.t_status == 4 ? text("[]", at) : text("[]", tt)), (src.holding ? text("<BR>(<A href='?src=\ref[];tank=1'>Tank ([]</A>)", src, src.holding.gas.tot_gas()) : null), src, num2text(max_valve, 7), src, src, src, src, src.t_per, src, src, src, src, src, num2text(max_valve, 7), ct, src, num2text(max_valve, 7), src, src, src, src, src.c_per, src, src, src, src, src, num2text(max_valve, 7), user)
	user << browse(dat, "window=siphon;size=600x300")
	return

/obj/machinery/atmoalter/siphs/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained())
		return
	if ((!( src.alterable )) && (!istype(usr, /mob/ai)))
		return
	if (((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf)) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["c"])
			var/c = text2num(href_list["c"])
			switch(c)
				if(1.0)
					src.c_status = 1
				if(2.0)
					src.c_status = 2
				if(3.0)
					src.c_status = 3
				else
		else
			if (href_list["t"])
				var/t = text2num(href_list["t"])
				if (src.t_status == 0)
					return
				switch(t)
					if(1.0)
						src.t_status = 1
					if(2.0)
						src.t_status = 2
					if(3.0)
						src.t_status = 3
					if(4.0)
						src.t_status = 4
						src.f_time = 1
					else
			else
				if (href_list["tp"])
					var/tp = text2num(href_list["tp"])
					src.t_per += tp
					src.t_per = min(max(round(src.t_per), 0), max_valve)
				else
					if (href_list["cp"])
						var/cp = text2num(href_list["cp"])
						src.c_per += cp
						src.c_per = min(max(round(src.c_per), 0), max_valve)
					else
						if (href_list["tank"])
							var/cp = text2num(href_list["tank"])
							if (cp == 1)
								src.holding.loc = src.loc
								src.holding = null
								if (src.t_status == 2)
									src.t_status = 3
		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=canister")
		return
	return

/obj/machinery/atmoalter/siphs/attackby(var/obj/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/tank))
		if (src.holding)
			return
		var/obj/item/weapon/tank/T = W
		user.drop_item()
		T.loc = src
		src.holding = T
	else
		if (istype(W, /obj/item/weapon/screwdriver))
			var/obj/machinery/connector/con = locate(/obj/machinery/connector, src.loc)
			var/obj/a_pipe/connector/con2 = locate() in src.loc
			if (src.c_status)
				src.anchored = 0
				src.c_status = 0
				user.show_message("\blue You have disconnected the siphon.")
				if(con)
					con.connected = null
				if(con2)
					con2.p_zone.tanks -= src
			else
				if (con && !con.connected)
					src.anchored = 1
					src.c_status = 3
					user.show_message("\blue You have connected the siphon.")
					con.connected = src
				else if(con2)
					src.anchored = 1
					src.c_status = 3
					user.show_message("\blue You have connected the siphon.")
					con2.p_zone.tanks += src
				else
					user.show_message("\blue There is nothing here to connect to the siphon.")


		else
			if (istype(W, /obj/item/weapon/wrench))
				src.alterable = !( src.alterable )
				if (src.alterable)
					user << "\blue You unlock the interface!"
				else
					user << "\blue You lock the interface!"
	return

obj/machinery/airlock_control_panel
	icon = 'icons/ss13/door1.dmi'
	icon_state = "airlockpanel"
	var
		cycle_status = 0 //0 - no cycle, 1 - to interior, 2 - to exterior

		last_ext_pressure = 0
		last_ext_oxygen = 0
		last_ext_plasma = 0
		last_ext_co2 = 0
		last_ext_sl_gas = 0

		last_int_pressure = 1
		last_int_oxygen = 0
		last_int_plasma = 0
		last_int_co2 = 0
		last_int_sl_gas = 0

		last_ext_temperature = 2.7
		last_int_temperature = T20C

		last_airlock_pressure = 1
		last_airlock_oxygen = 0
		last_airlock_plasma = 0
		last_airlock_co2 = 0
		last_airlock_sl_gas = 0
		last_airlock_temperature = T20C

		id = ""

		obj/machinery/gas_sensor
			airlocksensor
			extsensor
			intsensor
		obj/machinery/atmoalter/siphs/airlock_reg
		obj/machinery/door
			int_airlock
			ext_airlock
	New()
		. = ..()
		sleep(5)
		for(var/obj/machinery/gas_sensor/G)
			if(G.id == id)
				airlocksensor = G
			else if(G.id == "[id]-gasext")
				extsensor = G
			else if(G.id == "[id]-gasint")
				intsensor = G
	process()
		switch(cycle_status)
			if(1)
				if(last_airlock_pressure < last_int_pressure - 0.05)
					if(airlock_reg.t_status != 4)
						createmessagetomachine(airlock_reg,"VALVE AUTO")
				else if(last_airlock_pressure > last_int_pressure + 0.05)
					if(airlock_reg.t_status != 1)
						createmessagetomachine(airlock_reg,"VALVE SIPHON")
					createmessagetomachine(airlock_reg,"VALVE RATE [1000000*abs(last_airlock_pressure - last_int_pressure)]")
				else
					if(airlock_reg.t_status != 3)
						createmessagetomachine(airlock_reg,"VALVE STOP")
			if(2)
				if(last_airlock_pressure < last_ext_pressure - 0.05)
					if(airlock_reg.t_status != 4)
						createmessagetomachine(airlock_reg,"VALVE AUTO")
				else if(last_airlock_pressure > last_ext_pressure + 0.05)
					if(airlock_reg.t_status != 1)
						createmessagetomachine(airlock_reg,"VALVE SIPHON")
					createmessagetomachine(airlock_reg,"VALVE RATE [1000000*abs(last_airlock_pressure - last_ext_pressure)]")
				else
					if(airlock_reg.t_status != 3)
						createmessagetomachine(airlock_reg,"VALVE STOP")

		createmessagetomachine(airlocksensor,"SENSE")
		createmessagetomachine(extsensor,"SENSE")
		createmessagetomachine(intsensor,"SENSE")
	receivemessage(message,var/obj/machinery/source)
		var/command = uppertext(stripnetworkmessage(message))
		var/list/listofcommand = dd_text2list(command," ",null)
		switch(listofcommand[1])
			if("REPORT") //Got our signal back! Yaaay."
				var
					pressure = text2num(listofcommand[10] / 100)
					temperature = text2num(listofcommand[11])

					oxygen = text2num(listofcommand[4])
					co2 = text2num(listofcommand[5])
					plasma = text2num(listofcommand[6])
					n2o = text2num(listofcommand[7])

				if(source == extsensor)
					last_ext_pressure = pressure
					last_ext_oxygen = oxygen
					last_ext_co2 = co2
					last_ext_plasma = plasma
					last_ext_sl_gas = n2o
					last_ext_temperature = temperature
				else if(source == intsensor)
					last_int_pressure = pressure
					last_int_oxygen = oxygen
					last_int_co2 = co2
					last_int_plasma = plasma
					last_int_sl_gas = n2o
					last_int_temperature = temperature
				else if(source == airlocksensor)
					last_airlock_pressure = pressure
					last_airlock_oxygen = oxygen
					last_airlock_co2 = co2
					last_airlock_plasma = plasma
					last_airlock_sl_gas = n2o
					last_airlock_temperature = temperature

	attack_hand(mob/user)
		var/tt = "<center><b><u>Airlock Controls</u></b></center><br><br>"
		tt += "Airlock Pressure: [round(last_airlock_pressure,0.1)] Bar"



//10,11