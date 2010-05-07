vs_control/var/PIPE_DELAY = 10 //One second between pipe transfers.
var/global/PIPERATE = 1E6

proc/zone_pass(obj/a_pipe/A,obj/a_pipe/B)
	//if(istype(A,/obj/a_pipe/divider) || istype(B,/obj/a_pipe/divider)) return 0
	if(A.p_dir & B.p_dir)
		if(!(A.does_not_zone & get_dir(A,B)) && !(B.does_not_zone & get_dir(B,A))) return 1
	return 0
proc/gas_pass(obj/a_pipe/A,obj/a_pipe/B)
	if(A.auto_connect & get_dir(A,B)) return 1
	if(B.auto_connect & get_dir(B,A)) return 1
	if(istype(A,/obj/a_pipe/divider/valve))
		if(!A:valve_open) return 0
	if(istype(B,/obj/a_pipe/divider/valve))
		if(!B:valve_open) return 0
	return zone_pass(A,B)

obj/above_piece
	var/obj/a_pipe/host
	//attack()
	//	call(host,"attack")(args)
	attack_hand()
		call(host,"attack_hand")(args)
	attack_paw()
		call(host,"attack_paw")(args)
	attack_ai()
		call(host,"attack_ai")(args)

obj/a_pipe
	icon = 'icons/ss13/reg_pipe.dmi'
	name = "pipe"
	dir = 4
	layer = 2.1
	parent_type = /obj/machinery
	anchored = 1
	//var/p_dir = 0
	//var/filters = -1
	var/pipe_zone/p_zone
	var/capacity = 6000000.0
	//var/list/links = list()

	var/discon = 0
	var/no_d_check = 0
	var/does_not_zone = 0
	var/auto_connect = 0

	var/insulation = NORMPIPERATE*2
	var/list/discon_images
	var/list/uc_images

	//Used to show above-floor pieces of an otherwise hidden pipe, e.g. vents, inlets.
	var/obj/above_piece/above
	var/use_above = ""

	proc/PipeProcess()

	proc/UnderFloor()
		var/turf/T = loc
		if ((src.level == 1 && isturf(src.loc) && T.intact))
			src.invisibility = 101
			if(!findtext(icon_state,"-f")) icon_state += "-f"

		else
			src.invisibility = null
			dd_replacetext(icon_state,"-f","")

	proc/Setup()
		if(text2num(icon_state) > 0)
			dir = text2num(icon_state)
		if(!p_dir)
			if(dir & (dir - 1))
				p_dir = dir
			else
				if(findtext(icon_state,"manifold"))
					p_dir = dir | turn(dir,90) | turn(dir,-90)
				else
					p_dir = dir | turn(dir,180)
		FindZone()
		/*while(1)
			if(ticker) break
			sleep(10)
		for(var/d in cardinal)
			if(auto_connect & d)
				var/obj/a_pipe/P = locate() in get_step(src,d)
				if(P)
					if(P.does_not_zone & get_dir(P,src)) continue
					P.p_zone.AddConnection(src.p_zone)*/
	proc/FindZone()
		if(p_zone) return
		for(var/d in cardinal)
			if(p_dir & d)
				if(does_not_zone & d) continue
				var/obj/a_pipe/A = locate() in get_step(src,d)
				if(A)
					if(A.does_not_zone & get_dir(A,src)) continue
					if(A.p_zone && !p_zone)
						A.p_zone.AddPipe(src)
						break
					//links += A
		if(!p_zone)
			new/pipe_zone(src)
	//verb/ShowZone()
	//	set src in view()
	//	if(p_zone) p_zone.Show()

	verb/ShowRawDelta()
		set src in view()
		usr << "delta: [p_zone.delta]"

	verb/ShowDeltaPercent()
		set src in view()
		usr << "delta: [p_zone.delta()]%"

	verb/ChkDiscon()
		set src in view()
		for(var/d in cardinal)
			ChkDisconD(d)
			ChkUnderD(d)

	proc/ChkUnderD(d)
		if(invisibility) return
		if(!(d & p_dir))
			//world << "N/A"
			return
		var/turf/T = get_step(src,d)
		if(T.density) return
		var/obj/a_pipe/P = locate() in T
		if(!P) return
		if(P.invisibility)
			if(!uc_images)
				uc_images = list()
			if("[d]" in uc_images) return
			uc_images += "[d]"
			/*var
				px = 0
				py = 0
			switch(d)
				if(NORTH)
					py = 32
				if(SOUTH)
					py = -32
				if(EAST)
					px = 32
				if(WEST)
					px = -32*/
			var/image/I = image('icons/Pipes.dmi',icon_state = "underc",dir=d)//,pixel_x = px,pixel_y = py)
			uc_images["[d]"] = I
			T.overlays += I
		else
			if("[d]" in uc_images)
				T.overlays -= uc_images["[d]"]
				uc_images -= "[d]"


	proc/ChkDisconD(d)
		//world << "<b>Cardinal Direction [d]</b>: \..."
		if(!(d & p_dir))
			//world << "N/A"
			return
		var/turf/T = get_step(src,d)
		if(d & no_d_check)
			if(discon & d)
				discon &= ~d
				overlays -= discon_images["[d]"]
				discon_images -= "[d]"
				p_zone.leaks -= T
			return
		var/obj/a_pipe/P = locate() in T
		if(!P)
			//world << "Disconnected."
			if(discon & d) return
			discon |= d
			if(!discon_images) discon_images = list()
			var/image/I = image('icons/Pipes.dmi',icon_state="discon",dir=d)
			overlays += I
			discon_images += "[d]"
			discon_images["[d]"] = I
			p_zone.leaks += T
		else
			//world << "Connected."
			if(!(discon & d)) return
			discon &= ~d
			overlays -= discon_images["[d]"]
			discon_images -= "[d]"
			p_zone.leaks -= T

	New()
		. = ..()
		if(findtext(name,"\[ALWAYSSHOW\]"))
			name = dd_replacetext(name," \[ALWAYSSHOW\]","")
			level = 2
		Setup()
		UnderFloor()
	Del()
		. = ..()

	hi_cap
		name = "high capacity pipe"
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "high_capacity"

	hi_manifold
		dir = 2
		name = "high capacity manifold"
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "hi_manifold"

	cross_manifold
		dir = 2
		name = "cross manifold"
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "cross_manifold"
		Setup()
			. = ..()

	manifold
		dir = 2
		name = "manifold"
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "manifold"

	vent
		dir = 2
		name = "vent"
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "vent"
		Setup()
			p_dir = dir
			FindZone()
		filter_vent
			icon_state = "vent0"
			//filters = 0

	inlet
		dir = 2
		name = "inlet"
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "inlet"
		//use_above = "-a"
		Setup()
			p_dir = dir
			FindZone()
		filter
			name = "filtered inlet"
			icon_state = "inlet_filter-0"
			var/f_mask = 0
			var/control = null
			PipeProcess()
				src.updateicon()
				if(!(stat & NOPOWER))
					var/turf/T = src.loc
					if(!T || T.density)	return

					var/obj/substance/gas/exterior = new()
					exterior.oxygen = T.oxygen()
					exterior.n2 = T.n2()
					exterior.plasma = T.poison
					exterior.co2 = T.co2()
					exterior.sl_gas = T.sl_gas
					exterior.temperature = T.temp()
					var/obj/substance/gas/interior = p_zone.gas
					var/obj/substance/gas/flowing = new()

					var/flow_rate = (exterior.tot_gas()-interior.tot_gas())*vsc.FLOWFRAC
					if(flow_rate <= 0)
						return
					flowing.set_frac(exterior,flow_rate)
					if(!(src.f_mask & GAS_O2))	flowing.oxygen	= 0
					if(!(src.f_mask & GAS_N2))	flowing.n2		= 0
					if(!(src.f_mask & GAS_PL))	flowing.plasma	= 0
					if(!(src.f_mask & GAS_CO2))	flowing.co2		= 0
					if(!(src.f_mask & GAS_N2O))	flowing.sl_gas	= 0
					use_power(5,ENVIRON)
					flowing.sub_delta_turf(T)
					interior.add_delta(flowing)
				return

			power_change()
				if(powered(ENVIRON))
					stat &= ~NOPOWER
				else
					stat |= NOPOWER
				spawn(rand(1,15))
					updateicon()
				return

			updateicon()
				if(stat & NOPOWER)
					icon_state = "inlet_filter-0"
					return
				if(src.p_zone.gas.tot_gas() > src.p_zone.gas.maximum/2)
					icon_state = "inlet_filter-4"
				else if(src.p_zone.gas.tot_gas() > src.p_zone.gas.maximum/3)
					icon_state = "inlet_filter-3"
				else if(src.p_zone.gas.tot_gas() > src.p_zone.gas.maximum/4)
					icon_state = "inlet_filter-2"
				else if(src.p_zone.gas.tot_gas() >= 1 || src.f_mask >= 1)
					icon_state = "inlet_filter-1"
				else
					icon_state = "inlet_filter-0"
				return
	connector
		dir = 2
		name = "connector"
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "connector"
		//use_above = "-a"
		//var/obj/machinery/atmoalter/connected
		Setup()
			p_dir = dir
			spawn(1)
				var/obj/machinery/atmoalter/A = locate(/obj/machinery/atmoalter, src.loc)

				if(A && A.c_status != 0)
					p_zone.tanks += A
					A.anchored = 1

			FindZone()
	he_pipe
		name = "heat exchange pipe"
		icon = 'icons/ss13/heat_pipe.dmi'
		insulation = HEATPIPERATE*2
		ChkDisconD(d)
			if(!(d & p_dir)) return
			var/turf/T = get_step(src,d)
			var/obj/a_pipe/P = locate() in T
			if(!P)
				if(discon & d) return
				discon |= d
				p_zone.leaks += T
			else
				if(!(discon & d)) return
				discon &= ~d
				p_zone.leaks -= T

	junction
		dir = 2
		name = "junction"
		icon = 'icons/ss13/junct-pipe.dmi'
		Setup()
			. = ..()
		ChkDisconD(d)
			if(!(d & p_dir)) return
			if(d == turn(dir,180))
				return ..()
			else
				var/turf/T = get_step(src,d)
				var/obj/a_pipe/P = locate() in T
				if(!P)
					if(discon & d) return
					discon |= d
					p_zone.leaks += T
				else
					if(!(discon & d)) return
					discon &= ~d
					p_zone.leaks -= T
	hi_junction
		dir = 2
		parent_type = /obj/a_pipe/junction
		icon = 'icons/ss13/pipes.dmi'
		icon_state = "hi_junction"
	divider
		icon = 'icons/ss13/pipes.dmi'
		var/pipe_zone/connect
		var/pipe_zone/connect2
		var/has_process = 0
		var/list/vleaks = list()
		Setup()
			p_dir = dir | turn(dir,180)
			does_not_zone = dir
			spawn(1)
				var/obj/a_pipe/P = locate() in get_step(src,turn(dir,180))
				if(P)
					if(P.p_zone)
						connect2 = P.p_zone
				P = locate() in get_step(src,dir)
				if(P)
					if(P.p_zone)
						connect = P.p_zone
			if(connect2)
				connect2.AddPipe(src)
			else FindZone()
			//p_zone = new/pipe_zone(src,1)
			//p_zone.AddPipe(src)
		ChkDisconD(d)
			//world << "<b>Cardinal Direction [d]</b>: \..."
			if(!(d & p_dir))
				//world << "N/A"
				return
			var/turf/T = get_step(src,d)
			if(d & no_d_check)
				if(discon & d)
					discon &= ~d
					overlays -= discon_images["[d]"]
					discon_images -= "[d]"
					vleaks -= T
				return
			var/obj/a_pipe/P = locate() in T
			if(!P)
				//world << "Disconnected."
				if(discon & d) return
				discon |= d
				if(!discon_images) discon_images = list()
				var/image/I = image('icons/Pipes.dmi',icon_state="discon",dir=d)
				overlays += I
				discon_images += "[d]"
				discon_images["[d]"] = I
				vleaks += T
			else
				//world << "Connected."
				if(!(discon & d)) return
				discon &= ~d
				overlays -= discon_images["[d]"]
				discon_images -= "[d]"
				vleaks -= T
		valve
			name = "valve"
			icon_state = "valve0"
			//use_above = "-a"
			var/valve_open = 0
			var/connect_on_open = 1
			dir = 2
			Setup()
				p_dir = dir | turn(dir,180)

				var/obj/a_pipe/divider
					d_div = locate() in get_step(src,dir)
					t_div = locate() in get_step(src,turn(dir,180))
				if(d_div && !t_div)
					does_not_zone = turn(dir,180) //Make the blocked direction away from any pumps if possible.
				else if(!d_div)
					does_not_zone = dir
				else
					connect_on_open = 0
				//If neither is a regular pipe, it's pointless to set a block or connect zones. The other pipes will do the work.
				if(!does_not_zone)
					new/pipe_zone(src,1)
					spawn(1) ChkDiscon()
				else
					spawn(1)
						var/obj/a_pipe/P = locate() in get_step(src,does_not_zone)
						if(P)
							if(P.p_zone)
								connect = P.p_zone
						P = locate() in get_step(src,turn(does_not_zone,180))
						if(P)
							if(P.p_zone)
								p_zone = P.p_zone
						ChkDiscon()
			attack_hand(mob/user)
				if(!valve_open)
					//if(!p_zone || !connect)
					//	flick("valve01",src)
					//	sleep(2)
					//	icon_state = "valve0"
					//	return
					flick("valve01",src)
					sleep(5)
					valve_open = 1
					icon_state = "valve1"
					if(!connect_on_open) return
					if(p_zone)
						if(connect) p_zone.AddConnection(connect)
						p_zone.leaks += vleaks
					else
						connect.leaks += vleaks
				else
					//if(!p_zone || !connect)
					//	flick("valve10",src)
					//	sleep(2)
					//	icon_state = "valve1"
					//	return
					flick("valve10",src)
					sleep(5)
					valve_open = 0
					icon_state = "valve0"
					if(!connect_on_open) return
					if(p_zone)
						if(connect) p_zone.RemoveConnection(connect)
						p_zone.leaks += vleaks
					else if(connect)
						connect.leaks += vleaks
			attack_paw(mob/user)
				return attack_hand(user)
			attack_ai(mob/ai/user)
				user.show_message("This valve is manually operated.")
				return
			digital_valve
				icon_state = "dvalve0"
				attack_hand(mob/user)
					if(!(stat & NOPOWER))
						if(!valve_open)
							//if(!p_zone || !connect)
							//	flick("valve01",src)
							//	sleep(2)
							//	icon_state = "valve0"
							//	return
							flick("dvalve01",src)
							sleep(5)
							valve_open = 1
							icon_state = "dvalve1"
							if(p_zone)
								if(connect) p_zone.AddConnection(connect)
								p_zone.leaks += vleaks
							else
								connect.leaks += vleaks
						else
							//if(!p_zone || !connect)
							//	flick("valve10",src)
							//	sleep(2)
							//	icon_state = "valve1"
							//	return
							flick("dvalve10",src)
							sleep(5)
							valve_open = 0
							icon_state = "dvalve0"
							if(p_zone)
								if(connect) p_zone.RemoveConnection(connect)
								p_zone.leaks -= vleaks
							else if(connect)
								connect.leaks -= vleaks
					else
						user << "Despite appearances, the handle is just an interface. You can't operate this without power."
				attack_ai(mob/ai/user)
					return attack_hand(user)
		pump
			dir = 2
			name = "pump"
			icon = 'icons/ss13/pipes2.dmi'
			icon_state = "pipepump-map"
			var/rate = 6000000.0
			PipeProcess()
				var/obj/a_pipe/divider/valve/P = locate() in get_step(src,dir)
				if(P)
					if(!P.valve_open) return
				P = locate() in get_step(src,turn(dir,180))
				if(P)
					if(!P.valve_open) return
				if(! (stat & NOPOWER) )  // pump if power
					if(p_zone && connect)
						connect.gas.transfer_from(connect2.gas, rate)
						connect.inflow += rate
						connect2.outflow += rate
					else if(connect)
						for(var/turf/T in vleaks)
							connect.gas.turf_add(T,rate)
					else if(p_zone)
						for(var/turf/T in vleaks)
							p_zone.gas.turf_take(T,rate)
					use_power(25, ENVIRON)

			updateicon()
				icon_state = "pipepump-[(stat & NOPOWER) ? "stop" : "run"]"
			power_change()
				if(powered(ENVIRON))
					stat &= ~NOPOWER
				else
					stat |= NOPOWER
				spawn(rand(1,15))	// So they don't all turn off at the same time
					updateicon()
		oneway
			dir = 2
			name = "one-way pipe"
			icon = 'icons/ss13/pipes.dmi'
			icon_state = "one-way"
			PipeProcess()
				var/obj/a_pipe/divider/valve/P = locate() in get_step(src,dir)
				if(P)
					if(!P.valve_open) return
				P = locate() in get_step(src,turn(dir,180))
				if(P)
					if(!P.valve_open) return
				if(connect && connect2)
					connect.gas.oneway_gas(connect2.gas,p_zone.CM(),connect.CM())
				else if(connect2)
					for(var/turf/T in vleaks)
						connect2.gas.oneway_from_turf(T,p_zone.CM())
				else if(connect)
					for(var/turf/T in vleaks)
						connect.gas.oneway_to_turf(T,connect.CM())
		a_circulator
			name = "circulator/heat exchanger"
			desc = "A gas circulator pump and heat exchanger."
			icon = 'pipes.dmi'
			icon_state = "circ1-off"
			p_dir = 3		// N & S
			var/side = 1 // 1=left 2=right
			var/status = 0
			var/rate = 1000000

			anchored = 1.0
			density = 1
			capmult = 1
			does_not_zone = 1
			capacity = 600000

			//var/pipe_zone/connect


			proc/control(var/on, var/prate)

				rate = prate/100*capacity

				if(status == 1)
					if(!on)
						status = 3
						spawn(30)
							if(status == 3)
								status = 0
								updateicon()
				else if(status == 0)
					if(on)
						status = (rate > 50 ? 1 : 2)
				else
					if(on)
						status = (rate > 50 ? 1 : 2)

				updateicon()


			updateicon()

				if(stat & NOPOWER)
					icon_state = "circ[side]-p"
					return

				var/is
				switch(status)
					if(0)
						is = "off"
					if(1)
						is = "run"
					if(2)
						is = "slow"
					if(3)
						is = "slow"

				icon_state = "circ[side]-[is]"



			power_change()
				..()
				updateicon()


			PipeProcess()
				if(! (stat & NOPOWER) )				// only do circulator step if powered
					if(!connect || !connect2)
						icon_state = "Fail!"
						return
					if(status==1 || status==2)
						var/obj/a_pipe/divider/valve/P = locate() in get_step(src,1)
						if(P)
							if(!P.valve_open) return
						P = locate() in get_step(src,2)
						if(P)
							if(!P.valve_open) return
						connect.gas.transfer_from(connect2.gas, status==1? rate : rate/2)
						connect.inflow += status==1? rate : rate/2
						connect2.outflow += status==1? rate : rate/2
						use_power(rate/capacity * 100)
	pipefilter
		dir = 2
		name = "Atmospheric Filter"
		icon = 'icons/ss13/pipes2.dmi'
		icon_state = "filter"
		//use_above = "-a"
		var/pipe_zone/filter_zone
		//filters = 0
		var/f_per = 300
		Setup()
			does_not_zone = dir
			p_dir = turn(dir,90) | turn(dir,-90) | dir
			spawn(1)
				var/obj/a_pipe/P = locate() in get_step(src,dir)
				if(P)
					filter_zone = P.p_zone
					P.no_d_check &= turn(dir,180)
					no_d_check = dir
					spawn(1) P.ChkDiscon()
				else
					filter_zone = get_step(src,dir)
					no_d_check = dir
			FindZone()
		proc/Filter(repeat)
			var/obj/a_pipe/divider/valve/P = locate() in get_step(src,dir)
			if(P)
				if(!P:valve_open) return
			if(!repeat)
				if(! (stat & NOPOWER) )
					use_power(min(src.f_per, 100),ENVIRON)
					var/obj/substance/gas/ndelta = src.get_extract()
					p_zone.gas.sub_delta(ndelta)
					if(istype(filter_zone,/pipe_zone))
						filter_zone.gas.add_delta(ndelta)
					else
						ndelta.turf_add(filter_zone,-1)
				AutoUpdateAI(src)
				src.updateUsrDialog()
			else
				var/obj/substance/gas/ndelta = src.get_extract()
				p_zone.gas.sub_delta(ndelta)
				if(istype(filter_zone,/pipe_zone))
					filter_zone.gas.add_delta(ndelta)
				else
					ndelta.turf_add(filter_zone,-1)
		proc/get_extract()
			var/obj/substance/gas/ndelta = new()
			if (src.f_mask & GAS_O2)
				ndelta.oxygen = min(src.f_per, src.p_zone.gas.oxygen)
			if (src.f_mask & GAS_N2)
				ndelta.n2 = min(src.f_per, src.p_zone.gas.n2)
			if (src.f_mask & GAS_PL)
				ndelta.plasma = min(src.f_per, src.p_zone.gas.plasma)
			if (src.f_mask & GAS_CO2)
				ndelta.co2 = min(src.f_per, src.p_zone.gas.co2)
			if (src.f_mask & GAS_N2O)
				ndelta.sl_gas = min(src.f_per, src.p_zone.gas.sl_gas)
			return ndelta
obj/a_meter
	parent_type = /obj/machinery
	anchored = 1
	icon = 'icons/Pipes.dmi'
	icon_state = "meter0"
	var/average
	New()
		. = ..()
		if(!(src in machines))
			machines += src
		//spawn(1) Update()
	Click()
		if(src in view(3))
			if(stat & BROKEN)
				return
			if(stat & NOPOWER)
				usr << "<b>No Power</b>"
				return
			var/obj/a_pipe/P = locate() in loc
			if(!P) return
			var/pipe_zone/PL = P.p_zone
		//	usr << "<u>[P]</u>"
		//	usr << "Oxygen: [PL.gas.oxygen]"
		//	usr << "Nitrogen: [PL.gas.n2]"
		//	usr << "Plasma: [PL.gas.plasma]"
		//	usr << "CO2: [PL.gas.co2]"
			//usr << "N2O: [PL.gas.sl_gas]"
			var/mf = round(average*1000,0.1)
			usr << "<b>Mass Flow: [min(mf,100)][(mf > 100?"+":"")]%" //6E6
			usr << "<b>Temperature: [PL.o_gas.temperature]K</b>"
			usr << "<b>Pressure: [(PL.o_gas.tot_gas() / CELLSTANDARD)*100]kPa</b>"
	process()
		if(1)
			//sleep(PIPE_DELAY)
			var/obj/a_pipe/P = locate() in loc
			if(!P)
				icon_state = "meterX"
				return
			if(stat & (BROKEN|NOPOWER))
				icon_state = "meter-p"
				return

			use_power(5)

			average = 0.5 * average + 0.5 * P.p_zone.delta()

			var/val = max(round(average * 189.99),0)
			if(val > 18)
				icon_state = "meterOTC" //It's off the scale, cap'n!
			else
				icon_state = "meter[val]"

var/list/pipe_zones = list()

pipe_zone
	var
		list
			contents = list()
			entrances = list()
			exits = list()
			connections = list()
			tanks = list()
			leaks = list()

		obj/substance/gas/gas = new()
		obj/substance/gas/o_gas = new()
		lowest_cap = 6000000.0
		inflow = 0
		outflow = 0
		delta = 0
		dis_check = 0

		shown = 0

	New(obj/a_pipe/start,no_spread)
		pipe_zones += src
		if(!no_spread)
			contents = GetConnectedPipes(start)
		else
			contents = list(start)
		for(var/obj/a_pipe/P in contents)
			P.p_zone = src
			gas.maximum += P.capacity
			if(P.type == /obj/a_pipe/inlet)
				leaks += P.loc
			if(istype(P,/obj/a_pipe/vent))
				exits += P.loc
		spawn Update()
		return src
	proc
		Update()
			while(1)
				sleep(vsc.PIPE_DELAY)
				if(!ticker) continue
				if(!dis_check)
					for(var/obj/a_pipe/P in contents)
						P.ChkDiscon()
					dis_check = 1
				o_gas.replace_by(gas)
				delta = 0
				inflow = 0
				outflow = 0
				//var/capmult = (contents.len + 1)
				for(var/obj/a_pipe/A in src)
					A.PipeProcess()
				if(shown) world << "=========[gas.maximum]=========="
				for(var/obj/machinery/atmoalter/A in tanks)
					var/flow = gas.flow_to_canister(A)
					if(flow > 0)
						inflow += flow// * 100
					else
						outflow += abs(flow)// * 100
				for(var/obj/a_pipe/pipefilter/F in contents)
					F.Filter()
				for(var/turf/T in exits)
					var/gt = vsc.FLOWFRAC * (gas.tot_gas() / CM())
					gas.turf_add(T,gt)
					outflow += gt
					if(shown)
						world << "Gas Released: [gt]"
						world << "New total is [gas.tot_gas()] [gas.temperature - T0C]C"
				for(var/pipe_zone/Z in connections)
					//ExchangeGas(Z)
					var/flow = gas.exchange_gas(Z.gas,CM(),Z.CM())
					if(flow > 0)
						inflow += flow// * 100
					else
						outflow += abs(flow)// * 100
					if(shown)
						world << "Gas Exchanged to New Zone"
						world << "New total is [gas.tot_gas()] [gas.temperature - T0C]C"
				for(var/obj/a_pipe/pipefilter/F in contents)
					F.Filter(1)
				for(var/turf/Z in leaks)
					var/flow = gas.leak_gas(Z,CM())
					if(flow < 0)
						inflow += abs(flow)// * 100
					else
						outflow += flow// * 100
					if(shown)
						world << "Gas Leaked to [Z]"
						world << "New total is [gas.tot_gas()] [gas.temperature - T0C]C"
				if(shown) world << "======================"
				var
					tot_node = gas.tot_gas() / contents.len
					numnodes = contents.len
					gtemp = gas.temperature
				if(tot_node>0.1)		// no pipe contents, don't heat
					for(var/obj/a_pipe/P in contents)		// for each segment of pipe
						P.heat_exchange(gas, tot_node, numnodes, gtemp) //, dbg)	// exchange heat with its turf
				delta = max(inflow,outflow)



		AddPipe(obj/a_pipe/P)
			contents += P
			P.p_zone = src

		AddConnection(pipe_zone/Z)
			if(Z == src) return
			if(!(Z in connections))
				Z.connections += src
				connections += Z

		RemoveConnection(pipe_zone/Z)
			connections -= Z
			Z.connections -= src

		Show()
			for(var/obj/a_pipe/P)
				P.overlays.len = 0
				P.p_zone.shown = 0
			for(var/obj/a_pipe/P in contents)
				P.overlays += 'Zone.dmi'
				for(var/d in cardinal)
					if(P.p_dir & d)
						P.overlays += image('Confirm.dmi',dir=d)
			shown = 1

		delta()
			if(!lowest_cap) return 0
			return delta/lowest_cap

		CM()
			return contents.len + 1



proc/GetConnectedPipes(obj/a_pipe/T)
	. = list()
	if(!istype(T,/obj/a_pipe))
		return .
	//if(istype(T,/obj/a_pipe/divider))
	//	. += T
	//	T = get_step(T,T.dir)
	//	T = locate(/obj/a_pipe) in T
	//	if(!T) return
	. += T
	var/borders = list()
	borders += T
	var/not_finished = 1
	while(not_finished)
		not_finished = 0
		for(var/obj/a_pipe/X in borders)
			var/list/pipe_set = list()
			for(var/d in cardinal)
				if(d & X.p_dir)
					if(d & X.does_not_zone) continue
					//X.ChkDisconD(d)
					pipe_set += get_step(X,d)
			for(var/turf/Y in pipe_set)
				for(var/atom/M in Y)
					if(M in .) continue
					else if(istype(M,/obj/a_pipe))
						if(!(M:p_dir & get_dir(M,X))) continue
						if(M:does_not_zone & get_dir(M,X)) continue
						. += M
						//if(istype(M,/obj/a_pipe/divider)) continue
						borders += M
						not_finished = 1
			borders -= X

obj/substance/gas/proc/exchange_gas(obj/substance/gas/target,SCM,TCM)
	var/amount = vsc.FLOWFRAC*(src.tot_gas() / SCM - target.tot_gas() / TCM)
	var/obj/substance/gas/delta_gt = new()
	if(amount > 0)
		delta_gt.set_frac(src,amount)
		. = -delta_gt.tot_gas()
		sub_delta(delta_gt)
		target.add_delta(delta_gt)
	else
		delta_gt.set_frac(target,-amount)
		. = delta_gt.tot_gas()
		target.sub_delta(delta_gt)
		add_delta(delta_gt)
obj/substance/gas/proc/oneway_gas(obj/substance/gas/target,SCM,TCM)
	var/amount = vsc.FLOWFRAC*(src.tot_gas() / SCM - target.tot_gas() / TCM)
	var/obj/substance/gas/delta_gt = new()
	if(amount > 0)
		delta_gt.set_frac(src,amount)
		. = -delta_gt.tot_gas()
		sub_delta(delta_gt)
		target.add_delta(delta_gt)

obj/substance/gas/proc/oneway_to_turf(turf/T,SCM)
	var/amount = vsc.FLOWFRAC*(src.tot_gas() / SCM - T.tot_gas() / 5)
	var/obj/substance/gas/delta_gt = new()
	if(amount > 0)
		delta_gt.set_frac(src,amount)
		. = -delta_gt.tot_gas()
		turf_add(T,delta_gt)

obj/substance/gas/proc/oneway_from_turf(turf/T,SCM)
	var/amount = vsc.FLOWFRAC*(T.tot_gas() / 5 - tot_gas() / SCM)
	var/obj/substance/gas/delta_gt = new()
	if(amount > 0)
		delta_gt.set_frac(T.get_gas(),amount)
		. = delta_gt.tot_gas()
		turf_take(T,delta_gt)

obj/substance/gas/proc/leak_gas(turf/T,SCM)
	var/amount = vsc.FLOWFRAC*(src.tot_gas() / SCM - T.tot_gas() * 0.2)
	//var/obj/substance/gas/delta_gt = new()
	if(amount > 0)
	//	delta_gt.set_frac(src,amount/2)
		//sub_delta(delta_gt)
		. = amount
		turf_add(T,amount)
	else
	//	var/obj/substance/gas/tgas = T.get_gas()
	//	delta_gt.set_frac(tgas,-amount/2)
		turf_take(T,-amount)
		. = amount

obj/substance/gas/proc/flow_to_canister(obj/machinery/atmoalter/A)
	var/amount
	if(A.c_status == 1)				// canister set to release
		//if(dbg) world.log << "C[tag]PC1: [gas.tot_gas()], [ngas.tot_gas()] <- [connected.gas.tot_gas()]"
		amount = min(A.c_per, 6000000.0 - tot_gas() )	// limit to space in connector
		amount = max(0, min(amount, A.gas.tot_gas() ) )		// limit to amount in canister, or 0
		//if(dbg) world.log << "C[tag]PC2: a=[amount]"
		//var/ng = ngas.tot_gas()
		transfer_from( A.gas, amount)
		//if(dbg) world.log <<"[ngas.tot_gas()-ng] from siph to connector"
		//if(dbg) world.log << "C[tag]PC3: [gas.tot_gas()], [ngas.tot_gas()] <- [connected.gas.tot_gas()]"
	else if(A.c_status == 2)		// canister set to accept

		amount = min(A.c_per, A.gas.maximum - A.gas.tot_gas())	//limit to space in canister
		amount = max(0, min(amount, tot_gas() ) )				// limit to amount in connector, or 0

		A.gas.transfer_from(src, amount)
	. = amount

/obj/a_pipe/pipefilter/var
	bypassed = 0
	locked = 1
	maxrate = 1E6
	emagged = 0
	f_mask = 0
/obj/a_pipe/pipefilter/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/f_print_scanner))
		return ..()
	if(istype(W, /obj/item/weapon/screwdriver))
		if(bypassed)
			user.show_message(text("\red Remove the foreign wires first!"), 1)
			return
		src.add_fingerprint(user)
		user.show_message(text("\red Now []securing the access system panel...", (src.locked) ? "un" : "re"), 1)
		sleep(30)
		locked =! locked
		user.show_message(text("\red Done!"),1)
		src.updateicon()
		return
	if(istype(W, /obj/item/weapon/cable_coil) && !bypassed)
		if(src.locked)
			user.show_message(text("\red You must remove the panel first!"),1)
			return
		var/obj/item/weapon/cable_coil/C = W
		if(C.use(4))
			user.show_message(text("\red You unravel some cable.."),1)
		else
			user.show_message(text("\red Not enough cable! <I>(Requires four pieces)</I>"),1)
		src.add_fingerprint(user)
		user.show_message(text("\red Now bypassing the access system... <I>(This may take a while)</I>"), 1)
		sleep(100)
		bypassed = 1
		src.updateicon()
		return
	if(istype(W, /obj/item/weapon/wirecutters) && bypassed)
		src.add_fingerprint(user)
		user.show_message(text("\red Now removing the bypass wires... <I>(This may take a while)</I>"), 1)
		sleep(50)
		bypassed = 0
		src.updateicon()
		return
	if(istype(W, /obj/item/weapon/card/emag) && (!emagged))
		emagged++
		src.add_fingerprint(user)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [] has shorted out the [] with an electromagnetic card!", user, src), 1)
		src.overlays += image('pipes2.dmi', "filter-spark")
		sleep(6)
		src.updateicon()
		return src.attack_hand(user)
	return src.attack_hand(user)

// pipefilter interact/topic
/obj/a_pipe/pipefilter/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/a_pipe/pipefilter/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/a_pipe/pipefilter/attack_hand(mob/user as mob)
	if(stat & NOPOWER)
		user << browse(null, "window=pipefilter")
		user.machine = null
		return

	var/list/gases = list("O2", "N2", "Plasma", "CO2", "N2O")
	user.machine = src
	var/dat = "Filter Release Rate:<BR>\n<A href='?src=\ref[src];fp=-[num2text(src.maxrate, 9)]'>M</A> <A href='?src=\ref[src];fp=-100000'>-</A> <A href='?src=\ref[src];fp=-10000'>-</A> <A href='?src=\ref[src];fp=-1000'>-</A> <A href='?src=\ref[src];fp=-100'>-</A> <A href='?src=\ref[src];fp=-1'>-</A> [src.f_per] <A href='?src=\ref[src];fp=1'>+</A> <A href='?src=\ref[src];fp=100'>+</A> <A href='?src=\ref[src];fp=1000'>+</A> <A href='?src=\ref[src];fp=10000'>+</A> <A href='?src=\ref[src];fp=100000'>+</A> <A href='?src=\ref[src];fp=[num2text(src.maxrate, 9)]'>M</A><BR>\n"
	for (var/i = 1; i <= gases.len; i++)
		dat += "[gases[i]]: <A HREF='?src=\ref[src];tg=[1 << (i - 1)]'>[(src.f_mask & 1 << (i - 1)) ? "Releasing" : "Passing"]</A><BR>\n"
	if(p_zone.gas.tot_gas())
		var/totalgas = p_zone.gas.tot_gas()
		var/pressure = round(totalgas / p_zone.gas.maximum * 100)
		var/nitrogen = p_zone.gas.n2 / totalgas * 100
		var/oxygen = p_zone.gas.oxygen / totalgas * 100
		var/plasma = p_zone.gas.plasma / totalgas * 100
		var/co2 = p_zone.gas.co2 / totalgas * 100
		var/no2 = p_zone.gas.sl_gas / totalgas * 100

		dat += "<BR>Gas Levels: <BR>\nPressure: [pressure]%<BR>\nNitrogen: [nitrogen]%<BR>\nOxygen: [oxygen]%<BR>\nPlasma: [plasma]%<BR>\nCO2: [co2]%<BR>\nN2O: [no2]%<BR>\n"
	else
		dat += "<BR>Gas Levels: <BR>\nPressure: 0%<BR>\nNitrogen: 0%<BR>\nOxygen: 0%<BR>\nPlasma: 0%<BR>\nCO2: 0%<BR>\nN2O: 0%<BR>\n"
	dat += "<BR>\n<A href='?src=\ref[src];close=1'>Close</A><BR>\n"

	user << browse(dat, "window=pipefilter;size=300x365")

/obj/a_pipe/pipefilter/Topic(href, href_list)
	..()
	if(usr.restrained() || usr.lying)
		return
	if(istype(usr,/mob/ai))
		var/mob/ai/AI = usr
		var/password = accesspasswords["[access_atmospherics]"]
		usr.machine = src
		if (href_list["close"])
			AI << browse(null, "window=pipefilter;")
			AI.machine = null
			return
		else if (href_list["fp"])
			AI.sendcommand("[password] RATE [text2num(href_list["fp"])]",src)
		else if (href_list["tg"])
			var/num = text2num(href_list["tg"])
			var/command = f_mask & num ? "PASS" : "RELEASE"
			if(num == GAS_O2)
				AI.sendcommand("[password] [command] O2",src)
			if(num == GAS_N2O)
				AI.sendcommand("[password] [command] N2O",src)
			if(num == GAS_PL)
				AI.sendcommand("[password] [command] PLASMA",src)
			if(num == GAS_N2)
				AI.sendcommand("[password] [command] N2",src)
			if(num == GAS_CO2)
				AI.sendcommand("[password] [command] CO2",src)

	else if ((((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["close"])
			usr << browse(null, "window=pipefilter;")
			usr.machine = null
			return
		if (src.allowed(usr) || src.emagged || src.bypassed)
			if (href_list["fp"])
				src.f_per = min(max(round(src.f_per + text2num(href_list["fp"])), 0), src.maxrate)
			else if (href_list["tg"])
				// toggle gas
				src.f_mask ^= text2num(href_list["tg"])
				src.updateicon()
		else
			usr.see("\red Access Denied ([src.name] operation restricted to authorized atmospheric technicians.)")
		AutoUpdateAI(src)
		src.updateUsrDialog()
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=pipefilter")
		usr.machine = null
		return

/obj/a_pipe/pipefilter/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	spawn(rand(1,15))	//so all the filters don't come on at once
		updateicon()

/obj/a_pipe/pipefilter/updateicon()
	src.overlays = null
	if(stat & NOPOWER)
		icon_state = "filter-off"
	else
		icon_state = "filter"
		if(emagged)	//only show if powered because presumeably its the interface that has been fried
			src.overlays += image('pipes2.dmi', "filter-emag")
		if (src.f_mask & (GAS_N2O|GAS_PL))
			src.overlays += image('pipes2.dmi', "filter-tox")
		if (src.f_mask & GAS_O2)
			src.overlays += image('pipes2.dmi', "filter-o2")
		if (src.f_mask & GAS_N2)
			src.overlays += image('pipes2.dmi', "filter-n2")
		if (src.f_mask & GAS_CO2)
			src.overlays += image('pipes2.dmi', "filter-co2")
	if(!locked)
		src.overlays += image('pipes2.dmi', "filter-open")
		if(bypassed)	//should only be bypassed if unlocked
			src.overlays += image('pipes2.dmi', "filter-bypass")

/obj/a_pipe/pipefilter/receivemessage(message,sender)
	if(..())
		return
	var/list/listofcommand = getcommandlist(message)
	if(listofcommand.len < 3)
		return
	if(check_password(listofcommand[1]))
		if(listofcommand[2] == "RATE")
			var/num = text2num(listofcommand[3])
			src.f_per = min(max(round(src.f_per + num), 0), src.maxrate)
		if(listofcommand[2] == "RELEASE")
			if(listofcommand[3] == "PLASMA")
				if(!(src.f_mask & GAS_PL))
					src.f_mask ^= GAS_PL
			else if(listofcommand[3] == "O2")
				if(!(src.f_mask & GAS_O2))
					src.f_mask ^= GAS_O2
			else if(listofcommand[3] == "CO2")
				if(!(src.f_mask & GAS_CO2))
					src.f_mask ^= GAS_CO2
			else if(listofcommand[3] == "N2")
				if(!(src.f_mask & GAS_N2))
					src.f_mask ^= GAS_N2
			else if(listofcommand[3] == "N2O")
				if(!(src.f_mask & GAS_N2O))
					src.f_mask ^= GAS_N2O
		else if(listofcommand[2] == "PASS")
			if(listofcommand[3] == "PLASMA")
				if((src.f_mask & GAS_PL))
					src.f_mask ^= GAS_PL
			else if(listofcommand[3] == "O2")
				if((src.f_mask & GAS_O2))
					src.f_mask ^= GAS_O2
			else if(listofcommand[3] == "CO2")
				if((src.f_mask & GAS_CO2))
					src.f_mask ^= GAS_CO2
			else if(listofcommand[3] == "N2")
				if((src.f_mask & GAS_N2))
					src.f_mask ^= GAS_N2
			else if(listofcommand[3] == "N2O")
				if((src.f_mask & GAS_N2O))
					src.f_mask ^= GAS_N2O
		else if(listofcommand[2] == "TOGGLE")
			if(listofcommand[3] == "PLASMA")
				src.f_mask ^= GAS_PL
			else if(listofcommand[3] == "O2")
				src.f_mask ^= GAS_O2
			else if(listofcommand[3] == "CO2")
				src.f_mask ^= GAS_CO2
			else if(listofcommand[3] == "N2")
				src.f_mask ^= GAS_N2
			else if(listofcommand[3] == "N2O")
				src.f_mask ^= GAS_N2O


/obj/a_pipe/proc/heat_exchange(var/obj/substance/gas/gas, var/tot_node, var/numnodes, var/temp, var/dbg=0)
//Args: Gas of pipeline, total gas in one pipe segment, number of nodes, temp of pipeline.


	var/turf/T = src.loc		// turf location of pipe
	if(T.density) return

	if( level != 1)				// no heat exchange for under-floor pipes
		if(istype(T,/turf/space))		// heat exchange less efficient in space (no conduction)
			gas.temperature += ( T.temp() - temp) / (3.0 * insulation * numnodes)
		else

	//		if(dbg) world.log << "PHE: ([x],[y]) [T.temp]-> \..."
			var/delta_T = (T.temp() - temp) / (insulation)	// normal turf

			gas.temperature += delta_T	/ numnodes			// heat the pipe due to turf temperature

			/*
			if(abs(delta_T*tot_node/T.tot_gas()) > 1)
				world.log << "Turf [T] at [T.x],[T.y]: gt=[temp] tt=[T.temp]"
				world.log << "dT = [delta_T] tn=[tot_node] ttg=[T.tot_gas()] tt-=[delta_T*tot_node/T.tot_gas()]"

			*/
			var/tot_turf = max(1, T.tot_gas())
			T.temp(-(delta_T*min(10,tot_node/tot_turf)))			// also heat the turf due to pipe temp
							// clamp max temp change to prevent thermal runaway
							// if low amount of gas in turf
	//		if(dbg) world.log << "[T.temp] [tot_turf] #[delta_T]"
			T.res_vars()	// ensure turf tmp vars are updated

	else								// if level 1 but in space, perform cooling anyway - exposed pipes
		if(istype(T,/turf/space))
			gas.temperature += ( T.temp() - temp) / (3.0 * insulation * numnodes)