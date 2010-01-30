/obj/machinery/sprinkler
	name = "Fire Suppression Emitter"
	icon = 'stationobjs.dmi'
	icon_state = "sprinkler"
	var/status = 1.0
	var/operating = 0
	anchored = 1.0
	var/invuln = null

/obj/machinery/sprinkler/process()
	if (!operating || !status)
		icon_state = "sprinkler"
		return
	if(stat & (NOPOWER|BROKEN))
		icon_state = "sprinkler"
		return
	use_power(75, ENVIRON)
	var/turf/T = src.loc
//	T.n2 += 1000000
//	T.co2 += 10000
	icon_state = "sprinkler1"
	var/obj/effects/water/W = new /obj/effects/water( T )
	W.dir = pick(1, 2, 4, 8)
	spawn( 0 )
		W.Life()

/obj/machinery/sprinkler/power_change()
	if( powered(ENVIRON) )
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

/obj/machinery/sprinkler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		src.status = !src.status
		viewers(user, null) << text("\red [] has [] []'s power supply!", user,(src.status ? "connected" : "disconnected"), src)
		user.add_medal("Firefighter",1,1,10)
