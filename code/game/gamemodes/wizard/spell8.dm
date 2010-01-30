///obj/beam/m_missile
//	name = "a magic missile"
//	icon = 'weap_sat.dmi'
//	icon_state = "plasma"
//	density = 1
//	var/yo = null
//	var/xo = null
//	var/current = null
//	var/life = 50.0
//	anchored = 1.0
//	flags = 2.0


/client/proc/magicmissile(atom/target as mob in oview())
	set category = "Spells"
	set name = "Magic missile"
	set desc="Whom"
	if(usr.stat >= 2)
		usr << "Not when you're dead!"
		return
	if(!istype(usr:wear_suit, /obj/item/weapon/clothing/suit/wizrobe))
		usr << "I don't feel strong enough without my robe."
		return
	if(!istype(usr:shoes, /obj/item/weapon/clothing/shoes/sandal))
		usr << "I don't feel strong enough without my sandals."
		return
	if(!istype(usr:head, /obj/item/weapon/clothing/head/wizhat))
		usr << "I don't feel strong enough without my hat."
		return
	if(!istype(usr:l_hand, /obj/item/weapon/staff) && !istype(usr:r_hand, /obj/item/weapon/staff))
		usr << "I don't feel strong enough without my staff."
		return
	var/turf/T = usr.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U, /turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if(U == T)
		usr.las_act()
		return
	if(!istype(U, /turf))
		return

	var/obj/beam/a_laser/A = new /obj/beam/a_laser( usr.loc )
	A.icon_state = "plasma"
	A.name = "a magic missile"

	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	usr.next_move = world.time + 4
//	A.process()
//	return
	gay
	if (A == null)
		return
///obj/beam/m_missile/proc/process()
	//world << text("laser at [] []:[], target is [] []:[]", src.loc, src.x, src.y, src:current, src.current:x, src.current:y)
	if ((!( A.current ) || A.loc == A.current))
		A.current = locate(min(max(A.x + A.xo, 1), world.maxx), min(max(A.y + A.yo, 1), world.maxy), A.z)
		//world << text("current changed: target is now []. location was [],[], added [],[]", src.current, src.x, src.y, src.xo, src.yo)
	if ((A.x == 1 || A.x == world.maxx || A.y == 1 || A.y == world.maxy))
		//world << text("off-world, deleting")
		//SN src = null
		del(A)
		return
	step_towards(A, A.current)
	// make it able to hit lying-down folk
	var/list/dudes = list()
	for(var/mob/M in A.loc)
		dudes += M
	if(dudes.len)
		A.Bump(pick(dudes))
//		spawn (0)
//			if (A)
//				del (A)
	//world << text("laser stepped, now [] []:[], target is [] []:[]", src.loc, src.x, src.y, src.current, src.current:x, src.current:y)
	A.life--
	if (A.life == 0)
		//SN src = null
		del(A)
		return
//	if (A)
	spawn(1)
		goto gay
		return
	return

///obj/beam/m_missile/Bump(atom/A as mob|obj)
//	spawn(0)
//		if(A)
//			A.las_act(null, src)
//		del(src)