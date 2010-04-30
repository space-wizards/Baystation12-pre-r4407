#define PIPERATE 0.10
obj/a_pipe
	icon = 'icons/Pipes.dmi'
	var/p_dir = 0
	var/filters = -1
	var/pipe_zone/p_zone
	var/capacity = 6000000.0
	var/list/links = list()
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

	New()
		. = ..()
		Setup()
	Del()
		. = ..()

	vent
		icon_state = "vent"
		Setup()
			p_dir = dir
			FindZone()
			p_zone.exits += loc
		filter_vent
			icon_state = "vent0"
			filters = 0

	inlet
		icon_state = "inlet"
		Setup()
			p_dir = dir
			FindZone()
			p_zone.entrances += loc
		filter_inlet
			icon_state = "inlet0"
			filters = 0
	connector
		icon_state = "connector"
		Setup()
			p_dir = dir
			FindZone()
	divider
		Setup()
			p_dir = dir | turn(dir,180)
		valve
			icon_state = "valve0"
		pump
			icon_state = "pump0"
		filter
			icon_state = "filter"

pipe_zone
	var
		list
			contents = list()
			entrances = list()
			exits = list()
			connections = list()
			tanks = list()

		obj/substance/gas/gas = new()
		oxygen_per = 0
		plasma_per = 0
		n2_per = 0
		sl_per = 0
		co2_per = 0
		lowest_cap = 6000000.0

	New(obj/a_pipe/start)
		contents = GetConnectedPipes(start)
		for(var/obj/a_pipe/P in contents)
			P.p_zone = src
		spawn Update()
	proc
		Update()
			for(var/turf/T in entrances)
				gas.turf_take(T,lowest_cap * PIPERATE)
			for(var/turf/T in exits)
				gas.turf_add(T,lowest_cap * PIPERATE)
			for(var/pipe_zone/Z in connections)
				gas.exchange_gas(Z.gas,contents.len,Z.contents.len)



		AddPipe(obj/a_pipe/P)
			contents += P

		Show()
			for(var/obj/a_pipe/P)
				P.overlays.len = 0
			for(var/obj/a_pipe/P in contents)
				P.overlays += 'Zone.dmi'
				for(var/d in cardinal)
					if(P.p_dir & d)
						P.overlays += image('Confirm.dmi',dir=d)


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
				if(d && X.p_dir) pipe_set += get_step(X,d)
			for(var/turf/Y in pipe_set)
				for(var/atom/M in Y)
					if(istype(M,/obj/a_pipe/divider)) continue
					if(M in .) continue
					else if(istype(M,/obj/a_pipe))
						. += M
						borders += M
						not_finished = 1
			borders -= X

obj/substance/gas/proc/exchange_gas(obj/substance/gas/target,c_len,oc_len)
	var/flow = 15 // To be adjusted.
	var/div = c_len + oc_len
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

	oxygen = (o_diff_a + theo) * c_len
	target.oxygen = (o_diff_b + theo) * oc_len

	plasma = (p_diff_a + theo) * c_len
	target.plasma = (p_diff_b + theo) * oc_len

	n2 = (n_diff_a + theo) * c_len
	target.n2 = (n_diff_b + theo) * oc_len

	co2 = (c_diff_a + theo) * c_len
	target.co2 = (c_diff_b + theo) * oc_len

	sl_gas = (s_diff_a + theo) * c_len
	target.sl_gas = (s_diff_b + theo) * oc_len