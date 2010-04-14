
/obj/item/weapon/pipe/proc/turf_place(turf/station/floor/F, mob/user)
	if(!isturf(user.loc))
		return
	if(get_dist(F,user) > 1)
		user << "You can't lay a pipe at a place that far away."
		return
	if(user.loc == F)
		user << "You can't lay a pipe where you are already standing."
		return
	for(var/obj/machinery/m in F)
		if(m.p_dir || m.h_dir)
			user << "There's already pipe-compatible machinery there."
			return
	for(var/atom/o in F)
		if(o.density && !istype(o,/obj/machinery/door/window) && !istype(o,/obj/window))
			user << "\An [o.name] is in the way."
			return
	if(!(get_dir(F,user) in list(NORTH, SOUTH, EAST, WEST)))
		user << "You cannot place a pipe diagonally from your location"
		return
	place_pipe(F,user)

/obj/item/weapon/pipe/proc/link_pipe(obj/machinery/pipes/p)
	var/list/dirs = p.get_dirs()
	p.node1 = get_machine(p.level, p.loc, dirs[1])
	p.node2 = get_machine(p.level, p.loc, dirs[2])
	p.update()
	var/num = ((p.node1 && p.node1.ispipe())?1:0) + ((p.node2 && p.node2.ispipe())?1:0)
	if(num == 0)
		p.termination = 2
		var/obj/machinery/pipeline/PL = new()
		plines += PL
		var/pnum = plines.len
		PL.name = "pipeline #[pnum]"
		p.plnum = pnum
		p.pl = PL
		var/list/pipes = pipelist(null,p)
		PL.nodes = pipes
		PL.numnodes = pipes.len
		PL.capmult = PL.numnodes+1
		PL.setterm()
	else if(num == 1)
		p.termination = 1
		var/obj/machinery/pipes/o = (p.node1 && p.node1.ispipe())? p.node1 : p.node2
		//var/list/odirs = o.get_dirs()
		if(!o.node1)//get_machine(o.level, o.loc, odirs[1]) == p)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.termination--
		p.plnum = o.plnum
		p.pl = o.pl
		var/list/pipes = pipelist(null,p)
		p.pl.nodes = pipes
		p.pl.numnodes = pipes.len
		p.pl.capmult = p.pl.numnodes+1
		p.pl.setterm()
	else if(num == 2)
		p.termination = 0
		var/obj/machinery/pipes/o = p.node1
		var/obj/machinery/pipes/o2 = p.node2
		var/obj/machinery/pipes/end = (o.pl.nodes[o.pl.nodes.len]==o)? o.pl.nodes[1] : o.pl.nodes[o.pl.nodes.len]
		var/obj/machinery/pipeline/opl = o2.pl
		for(var/obj/machinery/pipes/P in opl.nodes)
			P.plnum = end.plnum
			P.pl = end.pl
		opl.nodes = list()
		//var/list/odirs = o.get_dirs()
		if(!o.node1)//get_machine(o.level, o.loc, odirs[1]) == p)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		//odirs = o2.get_dirs()
		if(!o2.node1)//get_machine(o2.level, o2.loc, odirs[1]) == p)
			o2.node1 = p
		else
			o2.node2 = p
		o2.overlays = null
		o2.update()
		var/list/pipes = pipelist(null,end)
		end.pl.nodes = pipes
		end.pl.numnodes = pipes.len
		end.pl.capmult = end.pl.numnodes+1
		end.pl.setterm()
		var/obj/machinery/pipes/oend = (end.pl.nodes[end.pl.nodes.len]==end)? end.pl.nodes[1] : end.pl.nodes[end.pl.nodes.len]
		if(oend.node1 && !istype(oend.node1,/obj/machinery/pipes))
			oend.node1.buildnodes()
		if(oend.node2 && !istype(oend.node2,/obj/machinery/pipes))
			oend.node2.buildnodes()
	if(p.node1 && !istype(p.node1,/obj/machinery/pipes))
		p.node1.buildnodes()
	if(p.node2 && !istype(p.node2,/obj/machinery/pipes))
		p.node2.buildnodes()

/obj/item/weapon/pipe/he/link_pipe(obj/machinery/pipes/heat_exch/p)
	var/list/dirs = p.get_dirs()
	p.node1 = get_he_machine(p.level, p.loc, dirs[1])
	p.node2 = get_he_machine(p.level, p.loc, dirs[2])
	p.update()
	var/num = ((p.node1 && p.node1.ispipe())?1:0) + ((p.node2 && p.node2.ispipe())?1:0)
	if(num == 0)
		p.termination = 2
		var/obj/machinery/pipeline/PL = new()
		plines += PL
		var/pnum = plines.len
		PL.name = "pipeline #[pnum]"
		p.plnum = pnum
		p.pl = PL
		var/list/pipes = pipelist(null,p)
		PL.nodes = pipes
		PL.numnodes = pipes.len
		PL.capmult = PL.numnodes+1
		PL.setterm()
	else if(num == 1)
		p.termination = 1
		var/obj/machinery/pipes/heat_exch/o = (p.node1 && p.node1.ispipe())? p.node1 : p.node2
		//var/list/odirs = o.get_dirs()
		if(!o.node1)//get_he_machine(o.level, o.loc, odirs[1]) == p)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.termination--
		p.plnum = o.plnum
		p.pl = o.pl
		var/list/pipes = pipelist(null,p)
		p.pl.nodes = pipes
		p.pl.numnodes = pipes.len
		p.pl.capmult = p.pl.numnodes+1
		p.pl.setterm()
	else if(num == 2)
		p.termination = 0
		var/obj/machinery/pipes/heat_exch/o = p.node1
		var/obj/machinery/pipes/heat_exch/o2 = p.node2
		var/obj/machinery/pipes/heat_exch/end = (o.pl.nodes[o.pl.nodes.len]==o)? o.pl.nodes[1] : o.pl.nodes[o.pl.nodes.len]
		var/obj/machinery/pipeline/opl = o2.pl
		for(var/obj/machinery/pipes/heat_exch/P in opl.nodes)
			P.plnum = end.plnum
			P.pl = end.pl
		opl.nodes = list()
		//var/list/odirs = o.get_dirs()
		if(!o.node1)//get_machine(o.level, o.loc, odirs[1]) == p)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		//odirs = o2.get_dirs()
		if(!o2.node1)//get_machine(o2.level, o2.loc, odirs[1]) == p)
			o2.node1 = p
		else
			o2.node2 = p
		o2.overlays = null
		o2.update()
		var/list/pipes = pipelist(null,end)
		end.pl.nodes = pipes
		end.pl.numnodes = pipes.len
		end.pl.capmult = end.pl.numnodes+1
		end.pl.setterm()
		var/obj/machinery/pipes/heat_exch/oend = (end.pl.nodes[end.pl.nodes.len]==end)? end.pl.nodes[1] : end.pl.nodes[end.pl.nodes.len]
		if(oend.node1 && !istype(oend.node1,/obj/machinery/pipes))
			oend.node1.buildnodes()
		if(oend.node2 && !istype(oend.node2,/obj/machinery/pipes))
			oend.node2.buildnodes()
	if(p.node1 && !istype(p.node1,/obj/machinery/pipes/heat_exch))
		p.node1.buildnodes()
	if(p.node2 && !istype(p.node2,/obj/machinery/pipes/heat_exch))
		p.node2.buildnodes()


/obj/item/weapon/pipe/proc/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North/South","East/West","cancel")
	var/obj/machinery/pipes/p = new(F)
	if(direction == "North/South")
		p.p_dir = NORTH | SOUTH
	else if(direction == "East/West")
		p.p_dir = EAST | WEST
	else
		del(p)
		return
	p.icon_state = "[p.p_dir]"
	link_pipe(p)
	del(src)

/obj/item/weapon/pipe/corner/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North/East","North/West","South/East","South/West","cancel")
	var/obj/machinery/pipes/p = new(F)
	if(direction == "North/East")
		p.p_dir = NORTH | EAST
	else if(direction == "North/West")
		p.p_dir = NORTH | WEST
	else if(direction == "South/East")
		p.p_dir = SOUTH | EAST
	else if(direction == "South/West")
		p.p_dir = SOUTH | WEST
	else
		del(p)
		return
	p.icon_state = "[p.p_dir]"
	link_pipe(p)
	del(src)

/obj/item/weapon/pipe/he/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North/South","East/West","cancel")
	var/obj/machinery/pipes/heat_exch/p = new(F)
	if(direction == "North/South")
		p.h_dir = NORTH | SOUTH
	else if(direction == "East/West")
		p.h_dir = EAST | WEST
	else
		del(p)
		return
	p.icon_state = "[p.h_dir]"
	link_pipe(p)
	del(src)

/obj/item/weapon/pipe/he/corner/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North/East","North/West","South/East","South/West","cancel")
	var/obj/machinery/pipes/heat_exch/p = new(F)
	if(direction == "North/East")
		p.h_dir = NORTH | EAST
	else if(direction == "North/West")
		p.h_dir = NORTH | WEST
	else if(direction == "South/East")
		p.h_dir = SOUTH | EAST
	else if(direction == "South/West")
		p.h_dir = SOUTH | WEST
	else
		del(p)
		return
	p.icon_state = "[p.h_dir]"
	link_pipe(p)
	del(src)

/obj/item/weapon/pipe/manifold/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North","East","South","West","cancel")
	var/obj/machinery/manifold/p = new(F)
	if(direction == "North")
		p.dir = NORTH
		p.p_dir = EAST | NORTH | WEST
	else if(direction == "East")
		p.dir = EAST
		p.p_dir = EAST | NORTH | SOUTH
	else if(direction == "South")
		p.dir = SOUTH
		p.p_dir = EAST | SOUTH | WEST
	else if(direction == "West")
		p.dir = WEST
		p.p_dir = WEST | NORTH | SOUTH
	else
		del(p)
		return
	//p.icon_state = "[p.h_dir]"
	//link_pipe(p)
	p.buildnodes()
	if(istype(p.node1,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node1
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node1))
		p.node1.buildnodes()
	if(istype(p.node2,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node2
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node2))
		p.node2.buildnodes()
	if(istype(p.node3,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node3
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node3))
		p.node3.buildnodes()
	del(src)

/obj/item/weapon/pipe/connector/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North","East","South","West","cancel")
	var/obj/machinery/connector/p = new(F)
	if(direction == "North")
		p.dir = NORTH
	else if(direction == "East")
		p.dir = EAST
	else if(direction == "South")
		p.dir = SOUTH
	else if(direction == "West")
		p.dir = WEST
	else
		del(p)
		return
	p.p_dir = p.dir
	p.buildnodes()
	if(istype(p.node,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node))
		p.node.buildnodes()
	del(src)

/obj/item/weapon/pipe/valve/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North/South","East/West","cancel")
	var/obj/machinery/valve/mvalve/p = new(F)
	if(direction == "North/South")
		p.dir = 2
		p.p_dir = 3
	else if(direction == "East/West")
		p.dir = 4
		p.p_dir = 12
	else
		del(p)
		return
	p.buildnodes()
	if(istype(p.node1,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node1
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node1))
		p.node1.buildnodes()
	if(istype(p.node2,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node2
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node2))
		p.node2.buildnodes()
	del(src)

/obj/item/weapon/pipe/valve/digital/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North/South","East/West","cancel")
	var/obj/machinery/valve/dvalve/p = new(F)
	if(direction == "North/South")
		p.dir = 2
		p.p_dir = 3
	else if(direction == "East/West")
		p.dir = 4
		p.p_dir = 12
	else
		del(p)
		return
	p.buildnodes()
	if(istype(p.node1,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node1
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node1))
		p.node1.buildnodes()
	if(istype(p.node2,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node2
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node2))
		p.node2.buildnodes()
	del(src)

/obj/item/weapon/pipe/vent/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North","East","South","West","cancel")
	var/obj/machinery/vent/p = new(F)
	if(direction == "North")
		p.dir = NORTH
	else if(direction == "East")
		p.dir = EAST
	else if(direction == "South")
		p.dir = SOUTH
	else if(direction == "West")
		p.dir = WEST
	else
		del(p)
		return
	p.p_dir = p.dir
	p.buildnodes()
	if(istype(p.node,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node))
		p.node.buildnodes()
	del(src)

/obj/item/weapon/pipe/inlet/place_pipe(turf/station/floor/F, mob/user)
	var/direction = input(user,"What directions should it face?","pipe direction","cancel") in list("North","East","South","West","cancel")
	var/obj/machinery/inlet/p = new(F)
	if(direction == "North")
		p.dir = NORTH
	else if(direction == "East")
		p.dir = EAST
	else if(direction == "South")
		p.dir = SOUTH
	else if(direction == "West")
		p.dir = WEST
	else
		del(p)
		return
	p.p_dir = p.dir
	p.buildnodes()
	if(istype(p.node,/obj/machinery/pipes))
		var/obj/machinery/pipes/o = p.node
		if(!o.node1)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		o.pl.setterm()
	else if(isobj(p.node))
		p.node.buildnodes()
	del(src)


