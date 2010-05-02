var/global/PIPE_DELAY = 10 //One second between pipe transfers.
var/global/PIPERATE = 1E6

obj/a_pipe
	icon = 'icons/Pipes.dmi'
	anchored = 1
	var/p_dir = 0
	var/filters = -1
	var/pipe_zone/p_zone
	var/capacity = 6000000.0
	var/list/links = list()
	var/discon = 0
	var/insulation = NORMPIPERATE
	var/list/discon_images
	proc/Setup()
		if(!p_dir)
			if(dir & (dir - 1))
				p_dir = dir
			else
				if(icon_state == "manifold")
					p_dir = dir | turn(dir,90) | turn(dir,-90)
				else
					p_dir = dir | turn(dir,180)
		FindZone()
	proc/FindZone()
		if(p_zone) return
		for(var/d in cardinal)
			if(p_dir & d)
				var/obj/a_pipe/A = locate() in get_step(src,d)
				if(A)
					if(A.p_zone && !p_zone) A.p_zone.AddPipe(src)
					links += A
			if(!p_zone)
				new/pipe_zone(src)
	verb/ShowZone()
		set src in view()
		if(p_zone) p_zone.Show()

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

	proc/ChkDisconD(d)
		//world << "<b>Cardinal Direction [d]</b>: \..."
		if(!(d & p_dir))
			//world << "N/A"
			return
		var/turf/T = get_step(src,d)
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
		Setup()
	Del()
		. = ..()

	manifold
		icon_state = "manifold"

	vent
		icon_state = "vent"
		Setup()
			p_dir = dir
			FindZone()
		filter_vent
			icon_state = "vent0"
			filters = 0

	inlet
		icon_state = "inlet"
		Setup()
			p_dir = dir
			FindZone()
		filter_inlet
			icon_state = "inlet0"
			filters = 0
	connector
		icon_state = "connector"
		Setup()
			p_dir = dir
			FindZone()
	heat_exchange_pipe
		icon_state = "he"
		insulation = HEATPIPERATE
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
		icon_state = "junction"
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
	divider
		Setup()
			p_dir = dir | turn(dir,180)
		valve
			icon_state = "valve0"
			var/valve_open = 0
			var/pipe_zone/connect
			Setup()
				p_dir = dir | turn(dir,180)
				spawn(1)
					var/obj/a_pipe/P = locate() in get_step(src,dir)
					if(P)
						if(P.p_zone)
							p_zone = P.p_zone
					P = locate() in get_step(src,turn(dir,180))
					if(P)
						if(P.p_zone)
							connect = P.p_zone
			Click()
				if(!valve_open)
					if(!p_zone || !connect)
						flick("valve01",src)
						sleep(2)
						icon_state = "valve0"
						return
					flick("valve01",src)
					sleep(5)
					valve_open = 1
					icon_state = "valve1"
					p_zone.AddConnection(connect)
				else
					if(!p_zone || !connect)
						flick("valve10",src)
						sleep(2)
						icon_state = "valve1"
						return
					flick("valve10",src)
					sleep(5)
					valve_open = 0
					icon_state = "valve0"
					p_zone.RemoveConnection(connect)
		pump
			icon_state = "pump0"
		filter
			icon_state = "filter"

obj/machinery/a_meter
	anchored = 1
	icon = 'icons/Pipes.dmi'
	icon_state = "meter0"
	var/average
	New()
		. = ..()
		spawn(1) Update()
	Click()
		if(src in view(3))
			var/obj/a_pipe/P = locate() in loc
			if(!P) return
			var/pipe_zone/PL = P.p_zone
		//	usr << "<u>[P]</u>"
		//	usr << "Oxygen: [PL.gas.oxygen]"
		//	usr << "Nitrogen: [PL.gas.n2]"
		//	usr << "Plasma: [PL.gas.plasma]"
		//	usr << "CO2: [PL.gas.co2]"
			//usr << "N2O: [PL.gas.sl_gas]"
			usr << "<b>Mass Flow: [round(average*1000,0.1)]%" //6E6
			usr << "<b>Temperature: [PL.gas.temperature]K</b>"
			usr << "<b>Pressure: [(PL.gas.tot_gas() / CELLSTANDARD)*100]kPa</b>"
	proc/Update()
		while(1)
			sleep(PIPE_DELAY)
			var/obj/a_pipe/P = locate() in loc
			if(!P)
				icon_state = "meterX"
				return
			if(stat & (BROKEN|NOPOWER))
				icon_state = "meter0"
				return

			use_power(5)

			average = 0.5 * average + 0.5 * P.p_zone.delta()

			var/val = round(average * 369.99)
			icon_state = "meter[val]"

var/list/pipe_zones = list()

turf/verb
	Make_Entrance()
		set src in view()
		for(var/pipe_zone/P in pipe_zones)
			if(P.shown)
				P.entrances += src
				world << "Done."
	Make_Exit()
		set src in view()
		for(var/pipe_zone/P in pipe_zones)
			if(P.shown)
				P.exits += src
				world << "Done."

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
		old_tot_gas = 0
	//	oxygen_per = 0
	//	plasma_per = 0
		//n2_per = 0
		//sl_per = 0
		//co2_per = 0
		lowest_cap = 6000000.0
		inflow = 0
		outflow = 0
		delta = 0
		dis_check = 0
		//gas_intake = CELLSTANDARD
		//gas_output = CELLSTANDARD

		shown = 0

	New(obj/a_pipe/start)
		pipe_zones += src
		contents = GetConnectedPipes(start)
		for(var/obj/a_pipe/P in contents)
			P.p_zone = src
			gas.maximum += P.capacity
			if(istype(P,/obj/a_pipe/inlet))
				entrances += P.loc
			if(istype(P,/obj/a_pipe/vent))
				exits += P.loc
		spawn Update()
	proc
		Update()
			while(1)
				sleep(PIPE_DELAY)
				if(!ticker) continue
				if(!dis_check)
					for(var/obj/a_pipe/P in contents)
						P.ChkDiscon()
					dis_check = 1
				delta = 0
				inflow = 0
				outflow = 0
				//var/capmult = (contents.len + 1)
				if(shown) world << "=========[gas.maximum]=========="
				for(var/turf/T in exits)
					//T.overlays += 'Blow.dmi'
					var/o_gas = gas.tot_gas()
					var/gt = min(gas.tot_gas(),PIPERATE)
					gas.turf_add(T,gt)
					outflow += gas.tot_gas() - o_gas
					if(shown)
						world << "Gas Released: [gt]"
						world << "New total is [gas.tot_gas()] [gas.temperature - T0C]C"
				for(var/turf/T in entrances)
					//T.overlays += 'Suck.dmi'
					var/tgas = T.tot_gas()
					var/sgas = gas.tot_gas()
					var/gt = min(tgas,max(0,gas.maximum-sgas),PIPERATE)
					gas.turf_take(T,gt)
					inflow += (gas.tot_gas() - sgas)
					if(shown)
						world << "Gas Taken: [gt]"
						world << "New total is [gas.tot_gas()] [gas.temperature - T0C]C"
				for(var/pipe_zone/Z in connections)
					//ExchangeGas(Z)
					var/flow = gas.exchange_gas(Z.gas,shown)
					if(flow > 0)
						inflow += flow
					else
						outflow += abs(flow)
					if(shown)
						world << "Gas Exchanged to New Zone"
						world << "New total is [gas.tot_gas()] [gas.temperature - T0C]C"
				for(var/turf/Z in leaks)
					var/flow = gas.leak_gas(Z,shown)
					if(flow > 0)
						inflow += flow
					else
						outflow += abs(flow)
					if(shown)
						world << "Gas Leaked to [Z]"
						world << "New total is [gas.tot_gas()] [gas.temperature - T0C]C"
				if(shown) world << "======================"
				delta = max(inflow,outflow)



		AddPipe(obj/a_pipe/P)
			contents += P

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



proc/GetConnectedPipes(obj/a_pipe/T)
	. = list()
	if(!istype(T,/obj/a_pipe))
		return .
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
					//X.ChkDisconD(d)
					pipe_set += get_step(X,d)
			for(var/turf/Y in pipe_set)
				for(var/atom/M in Y)
					if(istype(M,/obj/a_pipe/divider)) continue
					if(M in .) continue
					else if(istype(M,/obj/a_pipe))
						. += M
						borders += M
						not_finished = 1
			borders -= X

obj/substance/gas/proc/exchange_gas(obj/substance/gas/target,s)
	var/obj/substance/gas
		sdelta = new()
		tdelta = new()

	sdelta.transfer_from(src,min(tot_gas(),PIPERATE))
	if(s) world << "S-INIT: [sdelta.tot_gas()] [sdelta.temperature - T0C]C"
	tdelta.transfer_from(target,min(target.tot_gas(),PIPERATE))
	if(s) world << "T-INIT: [tdelta.tot_gas()] [tdelta.temperature - T0C]C"
	var/old_s = sdelta.tot_gas()
	sdelta.merge_into(tdelta)
	if(s) world << "MERGE: [sdelta.tot_gas()] [sdelta.temperature - T0C]C"
	tdelta.transfer_from(sdelta,sdelta.tot_gas()/2)
	sdelta.transfer_from(sdelta,sdelta.tot_gas())
	//world << "SPLIT: [sdelta.tot_gas()] [tdelta.tot_gas()]"

	if(s) world << "S-EXCHANGE: [sdelta.tot_gas()] [sdelta.temperature - T0C]C"
	. = sdelta.tot_gas() - old_s
	add_delta(sdelta)
	if(s) world << "T-EXCHANGE: [tdelta.tot_gas()] [tdelta.temperature - T0C]C"
	target.add_delta(tdelta)

	/*var/flow = 15 // To be adjusted.
	var/div = c_len + oc_len
	world << "[c_len]+[oc_len]"
	var
		t_oxygen = (oxygen + target.oxygen)/div
		t_plasma = (plasma + target.plasma)/div
		t_sl_gas = (sl_gas + target.sl_gas)/div
		t_n2 = (n2 + target.n2)/div
		t_co2 = (co2 + target.co2)/div

		o_diff_a = oxygen - t_oxygen
		o_diff_b = target.oxygen - t_oxygen

		p_diff_a = plasma - t_plasma
		p_diff_b = target.plasma - t_plasma

		n_diff_a = n2 - t_n2
		n_diff_b = target.n2 - t_n2

		c_diff_a = co2 - t_co2
		c_diff_b = target.co2 - t_co2

		s_diff_a = sl_gas - t_sl_gas
		s_diff_b = target.sl_gas - t_sl_gas



	o_diff_a *= 1 - (flow / 100)
	o_diff_b *= 1 - (flow / 100)

	p_diff_a *= 1 - (flow / 100)
	p_diff_b *= 1 - (flow / 100)

	n_diff_a *= 1 - (flow / 100)
	n_diff_b *= 1 - (flow / 100)

	c_diff_a *= 1 - (flow / 100)
	c_diff_b *= 1 - (flow / 100)

	s_diff_a *= 1 - (flow / 100)
	s_diff_b *= 1 - (flow / 100)

	oxygen = (o_diff_a + t_oxygen) * c_len
	target.oxygen = (o_diff_b + t_oxygen) * oc_len

	plasma = (p_diff_a + t_plasma) * c_len
	target.plasma = (p_diff_b + t_plasma) * oc_len

	n2 = (n_diff_a + t_n2) * c_len
	target.n2 = (n_diff_b + t_n2) * oc_len

	co2 = (c_diff_a + t_co2) * c_len
	target.co2 = (c_diff_b + t_co2) * oc_len

	sl_gas = (s_diff_a + t_sl_gas) * c_len
	target.sl_gas = (s_diff_b + t_sl_gas) * oc_len*/

obj/substance/gas/proc/leak_gas(turf/T,s)
	var/obj/substance/gas
		//target = T.get_gas()
		sdelta = new()
		tdelta = new()

	sdelta.transfer_from(src,min(tot_gas(),PIPERATE/2)) //The piperate is divided in half because this is called by both zones.
	if(s) world << "S-INIT: [sdelta.tot_gas()]"
	var/old_s = sdelta.tot_gas()
	tdelta.turf_take(T,min(T.tot_gas(),PIPERATE/2))
	if(s) world << "T-INIT: [tdelta.tot_gas()]"
	sdelta.merge_into(tdelta)
	if(s) world << "MERGE: [sdelta.tot_gas()]"
	tdelta.transfer_from(sdelta,sdelta.tot_gas()/2)
	sdelta.transfer_from(sdelta,sdelta.tot_gas())
	//world << "SPLIT: [sdelta.tot_gas()] [tdelta.tot_gas()]"

	if(s) world << "S-EXCHANGE: [sdelta.tot_gas()]"
	. = sdelta.tot_gas() - old_s
	add_delta(sdelta)
	if(s) world << "T-EXCHANGE: [tdelta.tot_gas()]"
	tdelta.turf_add(T,-1)