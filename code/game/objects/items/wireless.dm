/obj/item/weapon/wireless/
	var/obj/machinery/router/router
	var/cnetnum = 0
	var/datum/computernet/computernet = null
	var/uniqueid = null
	var/directwiredCnet = 1
	var/computerID = 0
	var/typeID = null
	var/netID = 0
	var/sniffer = 0
	var/ailabel = ""
	var/list/mob/ai/ais = list()


/obj/item/weapon/wireless/New()
	..()
	computerID = uppertext(num2hex(GetUnitId()))
	typeID = gettypeid(type)

/proc/GetTurf(var/obj/object)
	if(object.loc != null)
		return GetTurf(object.loc)
	return object

/obj/item/weapon/wireless/proc/UpdateWireless()
	var/turf/T = GetTurf(src)

	if(!T.wireless.Find(router))
		computernet.nodes.Remove(src)
		cnetnum = 0
		computernet = null

	if(T.wireless.len >= 1)
		router = T.wireless[1]
		cnetnum = router.wirelessnet.number
		computernet = router.wirelessnet
		computernet.nodes.Add(src)