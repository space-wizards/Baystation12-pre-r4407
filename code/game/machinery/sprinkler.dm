/obj/machinery/sprinkler
	name = "Fire Suppression Emitter"
	icon = 'stationobjs.dmi'
	icon_state = "sprinkler"
	anchored = 1.0
	var/status = 1.0
	var/operating = 0
	var/invuln = null
	var/list/spraydirs

/obj/machinery/sprinkler/New()
	..()
	src.spraydirs = list(1, 2, 4, 8) - turn(src.dir, 180)

/obj/machinery/sprinkler/process()
	if (!operating || !status)
		icon_state = "sprinkler"
		return
	if(stat & (NOPOWER|BROKEN))
		icon_state = "sprinkler"
		return
	use_power(75, ENVIRON)
	var/turf/T = src.loc
	icon_state = "sprinkler1"
	var/obj/effects/water/W = new /obj/effects/water( T )
	W.dir = pick(spraydirs)
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
		viewers(user, null) << text("\red [] has [] []'s power supply!", user, (src.status ? "connected" : "disconnected"), src)
		user.unlock_medal("Firefighter", 1, "Enable or disable firefighting apparatus", "easy")
