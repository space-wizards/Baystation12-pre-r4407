/datum/rtable
	var/list/list/datum/computernet/sourcenets = list()

/datum/rtable/proc/GetNetName(var/net)
	if (istype(net, /datum/computernet))
		var/datum/computernet/N = net
		return N.id
	else
		return net

var/dbg1
var/dbg2
var/dbg3

proc/BuildRoutingTable()
	set background = 1
	var/load = 0
	var/datum/rtable/R = new /datum/rtable()
	world.log << "Building routing table ([computernets.len] nets)"
	dbg1 = 0
	dbg2 = 0
	dbg3 = 0
	for (var/datum/computernet/srccnet in computernets)
		R.sourcenets[srccnet.id] = list()
	for (var/datum/computernet/srccnet in computernets)
		for (var/datum/computernet/destcnet in computernets)
			if (srccnet == destcnet || R.sourcenets[srccnet.id][destcnet.id])
				continue
			BuildRoutingPath(srccnet, destcnet, R)
			load++
			if(load >= 150)
				load = 0
				sleep(0)
	world.log << "Done.  1 [dbg1] [dbg2] [dbg3]"
	routingtable = R

proc/BuildRoutingPath(var/datum/computernet/srccnet, var/datum/computernet/destcnet, var/datum/rtable/R)
	dbg1++
	if (srccnet.routers.len == 0 || destcnet.routers.len == 0)
		R.sourcenets[srccnet.id][destcnet.id] = null
		return

	var/list/datum/computernet/path = SubBuildRoutingPath(srccnet, destcnet, list())

	R.sourcenets[srccnet.id][destcnet.id] = path
	if (path)
		dbg3++

proc/SubBuildRoutingPath(var/datum/computernet/curnet, var/datum/computernet/destcnet, var/list/ignore)
	dbg2++
	if (!curnet)
		return null
	if (curnet == destcnet)
		return list(curnet)

	ignore += curnet

	var/list/best = null

	for (var/obj/machinery/router/R in curnet.routers)
		ignore += R
		for (var/datum/computernet/cnet in R.connectednets)
			if (cnet in ignore)
				continue

			var/list/results = SubBuildRoutingPath(cnet, destcnet, ignore)

			if (!results)
				continue
			results += curnet

			return results //Comment out to use a slower but better "find-path" mechanism

			if (!best || best.len > results.len)
				best = results

	return best