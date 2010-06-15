// pipeline datum for storings inter-machine links
// create a pipeline

/obj/machinery/pipeline/New()
	..()

	gas = new/obj/substance/gas(src)
	ngas = new/obj/substance/gas()

	gasflowlist += src

// find the pipeline that contains the /obj/machine (including pipe)
/proc/findline(var/obj/machinery/M)

	for(var/obj/machinery/pipeline/P in plines)

		for(var/obj/machinery/O in P.nodes)

			if(M==O)
				return P

	return null

// sets the vnode1&2 terminators to the joining machines (or null)
/obj/machinery/pipeline/proc/setterm()
	if(!nodes || !nodes.len)
		return

	//first make sure pipes are oriented correctly

	var/obj/machinery/M = null


	for(var/obj/machinery/pipes/P in nodes)
		if(!M)			// special case for 1st pipe
			if(P.node1 && P.node1.ispipe())
				P.flip()		// flip if node1 is a pipe
		else
			if(P.node1 != M)		//other cases, flip if node1 doesn't point to previous node
				P.flip()			// (including if it is null)


		M = P


	// pipes are now ordered so that n1/n2 is in same order as pipeline list

	var/obj/machinery/pipes/P = nodes[1]		// 1st node in list
	vnode1 = P.node1							// n1 points to 1st machine
	P = nodes[nodes.len]						// last node in list
	vnode2 = P.node2							// n2 points to last machine


	return


/obj/machinery/pipeline/get_gas_val(from)
	return gas.tot_gas()/capmult

/obj/machinery/pipeline/get_gas(from)
	return gas

/obj/machinery/pipeline/gas_flow()
	//if(suffix == "d" && Debug) world.log << "PLF1  [gas.tot_gas()] ~ [ngas.tot_gas()]"

	gas.replace_by(ngas)

	//if(suffix == "d" && Debug) world.log << "PLF2  [gas.tot_gas()] ~ [ngas.tot_gas()]"

/obj/machinery/pipeline/process()

	if (!numnodes)
		return

	var/gtemp = ngas.temperature					// cached temperature for heat exch calc
	var/tot_node = ngas.tot_gas() / src.numnodes	// fraction of gas in this node


	if(tot_node>0.1)		// no pipe contents, don't heat
		for(var/obj/machinery/pipes/P in src.nodes)		// for each segment of pipe
			P.heat_exchange(ngas, tot_node, numnodes, gtemp) //, dbg)	// exchange heat with its turf


	// now do standard gas flow proc

	var/delta_gt

	if(vnode1)
		delta_gt = vsc.FLOWFRAC * ( vnode1.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode1, delta_gt)//, dbg)

		//if(dbg) world.log << "PLT1 [delta_gt] >> [gas.tot_gas()] ~ [ngas.tot_gas()]"

		flow = delta_gt
	else
		leak_to_turf(1)

	if(vnode2)
		delta_gt = vsc.FLOWFRAC * ( vnode2.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode2, delta_gt)//, dbg)

		//if(dbg) world.log << "PLT2 [delta_gt] >> [gas.tot_gas()] ~ [ngas.tot_gas()]"

		flow -= delta_gt
	else
		leak_to_turf(2)

/obj/machinery/pipes/New()
	..()
	name = replace(name, " \[ALWAYSSHOW]", "") //Remove a tag used on the map editor

/obj/machinery/pipeline/proc/leak_to_turf(var/port)
	var/turf/T
	var/obj/machinery/pipes/P
	var/list/ndirs

	switch(port)
		if(1)
			P = nodes[1]		// 1st node in list
			if (P==null)
				T = src.loc
			else
				ndirs = P.get_node_dirs()

				T = get_step_3d(P, ndirs[1])


		if(2)
			P = nodes[nodes.len]	// last node in list
			if (P==null)
				T = src.loc
			else

				ndirs = P.get_node_dirs()
				T = get_step_3d(P, ndirs[2])
	if (T==null)
		return
	if(T.density)
		return

	flow_to_turf(gas, ngas, T)

// build the pipelines
var/list/lines = list()
/proc/makepipelines()

	var/linecount = 0		// the line number
	lines = list()
	for(var/obj/machinery/pipes/P in machines)		// look for a pipe

		if(!P.plnum)							// if not already part of a line
			P.buildnodes(++linecount) // add it, and spread to all connected pipes
	for(var/L = 1 to linecount)					// for count of lines found
		var/obj/machinery/pipeline/PL = new()	// make a pipeline virtual object
		PL.name = "pipeline #[L]"
		PL.plnum = L
		plines += PL							// and add it to the list

	for(var/obj/machinery/pipes/P in machines)		// look for pipes

		if(P.termination)						// true if pipe is terminated (ends in blank or a machine)
			var/obj/machinery/pipeline/PL = plines[P.plnum]		// get the pipeline from the pipe's pl-number

			var/list/pipes = pipelist(null, P)	// get a list of pipes from P until terminated
			PL.nodes = pipes					// pipeline is this list of nodes
			PL.numnodes = pipes.len				// with this many nodes
			PL.capmult = PL.numnodes+1			// with this flow multiplier

	for(var/obj/machinery/pipes/P in machines)		// all pipes
		P.setline()								// 	set the pipeline object for this pipe

		if(P.tag == "dbg")		//add debug tag to line containing debug pipe
			P.pl.tag = "dbg"

		if(P.suffix == "dbgpp")		//add debug tag to line containing debug pipe
			P.pl.suffix = "dbgp"

		if(P.suffix == "d")		//add debug tag to line containing debug pipe
			P.pl.suffix = "d"


	for(var/obj/machinery/M in machines)			// for all machines
		if(M.p_dir)								// which are pipe-connected
			if(!M.ispipe())						// is not a pipe itself
				M.buildnodes()					// build the nodes, setting the links to the virtual pipelines
												// also sets the vnodes for the pipelines

	for(var/obj/machinery/pipeline/PL in plines)	// for all lines
		//Messes up plnum, thus removed.
		PL.setterm()								// orient the pipes and set the pipeline vnodes to the terminating machines

	for(var/obj/machinery/pipes/P in world)
		P.update()

// return a list of pipes (not including terminating machine)

/proc/pipelist(var/obj/machinery/source, var/obj/machinery/startnode)

	var/list/L = list()

	var/obj/machinery/node = startnode
	var/obj/machinery/prev = source
	var/obj/machinery/newnode

	while(node)
		if(node in L)
			break
		L += node
		newnode = node.next(prev)
		prev = node

		if(newnode && newnode.ispipe())
			node = newnode
		else
			break

	return L

// new pipes system

// flip the nodes of a pipe
/obj/machinery/pipes/proc/flip()
	var/obj/machinery/tempnode = node1
	node1 = node2
	node2 = tempnode
	return


// return the next pipe in the node chain
/obj/machinery/pipes/next(var/obj/machinery/from)

	if(from == null)		// if from null, then return the next actual pipe
		if(node1 && node1.ispipe() )
			return node1
		if(node2 && node2.ispipe() )
			return node2
		return null			// else return null if no real pipe connected

	else if(from == node1)		// otherwise, return the node opposite the incoming one
		return node2
	else
		return node1


// set the pipeline obj from the pl-number and global list of pipelines

/obj/machinery/pipes/setline()
	src.pl = plines[plnum]
	return

// returns the pipeline that this line is in

/obj/machinery/pipes/getline()
	return pl

/obj/machinery/pipes/orient_pipe(P as obj)
	if (!( src.node1 ))
		src.node1 = P
	else
		if (!( src.node2 ))
			src.node2 = P
		else
			return 0
	return 1

// returns a list of dir1, dir2 & p_dir for a pipe

/obj/machinery/pipes/proc/get_dirs()
	var/b1
	var/b2

	for(var/d in cardinal)
		if(p_dir & d)
			if(!b1)
				b1 = d
			else if(!b2)
				b2 = d

	return list(b1, b2, p_dir)

// returns a list of the directions of a pipe, matched to nodes (if present)

/obj/machinery/pipes/proc/get_node_dirs()
	var/list/dirs = get_dirs()


	if(!node1 && !node2)		// no nodes - just return the standard dirs
		return dirs				// note extra p_dir on end of list is unimportant
	else
		if(node1)
			var/d1 = get_dir(src, node1)		// find the direction of node1
			if(d1==dirs[1])						// if it matches
				return dirs						// then dirs list is correct
			else
				return list(dirs[2], dirs[1])	// otherwise return the list swapped

		else		// node2 must be valid
			var/d2 = get_dir(src, node2)		// direction of node2
			if(d2==dirs[2])						// matches
				return dirs						// dirs list is correct
			else
				return list(dirs[2], dirs[1])	// otherwise swap order


/obj/machinery/pipes/proc/update()

	var/turf/T = src.loc

	var/list/dirs = get_dirs()

	var/is = "[dirs[3]]"

	if(stat & BROKEN)
		is += "-b"

	if ((src.level == 1 && isturf(src.loc) && T.intact))
		src.invisibility = 101
		is += "-f"

	else
		src.invisibility = null

	src.icon_state = is

	if(node1 && node2)
		overlays = null
	else if(!node1 && !node2)
		overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[1])
		overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[2])
	else if(!node1)
		var/d2 = get_dir(src, node2)
		if(dirs[1] == d2)
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[2])
		else
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[1])
	else if(!node2)
		var/d1 = get_dir(src, node1)
		if(dirs[1] == d1)
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[2])
		else
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[1])


	return

/obj/machinery/pipes/hide(var/i)
	update()

/obj/machinery/pipes/proc/explode()

	//*****
//	world << "pipe [src] at [x],[y],[z] exploded"

//	src.gas.turf_add(src.loc, -1.0)
	return

/obj/machinery/pipes/ispipe()		// return true since this is a pipe
	return 1

/obj/machinery/pipes/buildnodes(var/linenum)

	if(plnum)
		return

	var/list/dirs = get_dirs()

	var/nodes = 0

	node1 = get_machine(level, src.loc, dirs[1])
	node2 = get_machine(level, src.loc, dirs[2])

	update()

	plnum = linenum

	termination = 0

	if(node1 && node1.ispipe() )

		nodes += node1.buildnodes(linenum)
	else
		termination++

	if(node2 && node2.ispipe() )
		nodes += node2.buildnodes(linenum)
	else
		termination++

	return nodes + 1

/obj/machinery/pipes/heat_exch/get_dirs()
	var/b1
	var/b2

	for(var/d in cardinal)
		if(h_dir & d)
			if(!b1)
				b1 = d
			else if(!b2)
				b2 = d

	return list(b1, b2, h_dir)

/obj/machinery/pipes/heat_exch/buildnodes(var/linenum)

	if(plnum)
		return

	src.level = 2		// h/e pipe cannot be put underfloor

	var/list/dirs = get_dirs()

	node1 = get_he_machine(level, src.loc, dirs[1])
	node2 = get_he_machine(level, src.loc, dirs[2])

	update()

	plnum = linenum

	termination = 0

	if(node1 && node1.ispipe() )

		node1.buildnodes(linenum)
	else
		termination++

	if(node2 && node2.ispipe() )
		node2.buildnodes(linenum)
	else
		termination++


/obj/machinery/pipes/proc/heat_exchange(var/obj/substance/gas/gas, var/tot_node, var/numnodes, var/temp, var/dbg=0)


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

// finds the machine with compatible p_dir in 1 step in dir from S
/proc/get_machine(var/level, var/turf/S, mdir)

	var/flip = reverse_dir_3d(mdir)

	var/turf/T = get_step_3d(S, mdir)

	for(var/obj/machinery/M in T.contents)
		if(M.p_dir & flip) //Removed an M.level == level check, because fuck that we neither need nor want such a check.
			return M

	return null

// finds the machine with compatible h_dir in 1 step in dir from S
/proc/get_he_machine(var/level, var/turf/S, mdir)

	var/flip = reverse_dir_3d(mdir)

	var/turf/T = get_step_3d(S, mdir)

	for(var/obj/machinery/M in T.contents)
		if(M.level == level)
			if(M.h_dir & flip)
				return M

	return null

/proc/calc_delta(obj/machinery/source, obj/substance/gas/sgas, obj/substance/gas/sngas, obj/machinery/target, amount, dbg=0)

	var/obj/substance/gas/tgas = target.get_gas(source)

	var/obj/substance/gas/ndelta = new()

	if(amount < 0)		// then flowing from source to target

		ndelta.set_frac(sgas, -amount)		// this is fraction of the gas which will be transfered to other node

		sngas.sub_delta(ndelta)		// subtract off the fraction which is gone

	else				// flowing from target to source

		ndelta.set_frac(tgas, amount)		// fraction of gas from the other node

		sngas.add_delta(ndelta)				// add the fraction to the new gas resv

/obj/substance/gas/proc/tostring()
	return "Tot: [src.tot_gas()] ; [oxygen]/[n2]/#[plasma]/[co2]/[sl_gas] ; Temp:[temperature]"


// standard proc for all machines - passed gas/ngas as arguments
// equilibrate a pipe object and a turf's gas content

/obj/machinery/proc/flow_to_turf(var/obj/substance/gas/sgas, var/obj/substance/gas/sngas, var/turf/T, var/dbg = 0)

	if(dbg) world.log << "FTT: G=[sgas.tostring()] ~ N=[sngas.tostring()]"
	if(dbg) world.log << "T=[T.tostring()]"



	var/t_tot = T.tot_gas() * 0.2		// partial pressure of turf gas at pipe, for the moment

	var/delta_gt = vsc.FLOWFRAC * ( t_tot - sgas.tot_gas() / capmult )

	if(dbg) world.log << "FTT: dgt=[delta_gt]"

	var/obj/substance/gas/ndelta = new()

	if(delta_gt < 0)	// flow from pipe to turf

		//world.log << "FTT<0"
		ndelta.set_frac(sgas, -delta_gt)		// ndelta contains gas to transfer to turf
		//world.log << "ND=[ndelta.tostring()]"
		sngas.sub_delta(ndelta)			// update new gas to remove the amount transfered
		//world.log << "SN=[sngas.tostring()]"
		ndelta.turf_add(T, -1)		// add all of ndelta to turf
		//world.log << "T=[T.tostring()]"

		//world.log << "LTT: [num2text(-delta_gt,10)] from [sgas.loc] to turf"


	else				// flow from turf to pipe
		if(dbg) world.log << "FTT>0"

		sngas.turf_take(T, delta_gt)		// grab gas from turf and direcly add it to the new gas
		if(dbg) world.log << "SN=[sngas.tostring()]"
		if(dbg) world.log << "T=[T.tostring()]"

		if(dbg) world.log << "LTT: [num2text(delta_gt,10)] from turf to [sgas.loc]"

	T.res_vars()	// update turf gas vars for both cases



/turf/proc/tostring()
	var/obj/substance/gas/G = src.get_gas()
	return G.tostring()

