
/obj/item/weapon/pipe/proc/turf_place(turf/station/floor/F, mob/user)
	if(!isturf(user.loc))
		return
	if(get_dist(F,user) > 1)
		user << "You can't lay a pipe at a place that far away."
		return
	if(user.loc == F)
		user << "You can't lay a pipe where you are already standing."
		return
	for(var/obj/machinery/pipes/p in F)
		user << "There's already a pipe there."
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
	var/num = (p.node1 && p.node1.ispipe())?1:0 + (p.node2 && p.node2.ispipe())?1:0
	if(num == 0)
		p.termination = 0
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
		var/list/odirs = o.get_dirs()
		if(get_machine(o.level, o.loc, odirs[1]) == p)
			o.node1 = p
		else
			o.node2 = p
		o.overlays = null
		o.update()
		p.plnum = o.plnum
		p.pl = o.pl
		var/list/pipes = pipelist(null,p)
		p.pl.nodes = pipes
		p.pl.numnodes = pipes.len
		p.pl.capmult = p.pl.numnodes+1
		p.pl.setterm()



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