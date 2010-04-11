/mob/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/shielded = 0
	for(var/obj/item/weapon/shield/S in src)
		if (S.active)
			shielded = 1
		else
	if (locate(/obj/item/weapon/grab, src))
		var/mob/safe = null
		if (istype(src.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.l_hand
			if ((G.state == 3 && get_dir(src, user) == src.dir))
				safe = G.affecting
		if (istype(src.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.r_hand
			if ((G.state == 3 && get_dir(src, user) == src.dir))
				safe = G.affecting
		if (safe)
			return safe.attackby(W, user)
	if ((!( shielded ) || !( W.flags ) & 32))
		spawn( 0 )
			W.attack(src, user)
			return
	return

/atom/proc/MouseDrop_T()
	return

/atom/proc/attack_hand(mob/user as mob)
	return

/atom/proc/attack_paw(mob/user as mob)
	return

/atom/proc/attack_ai(mob/user as mob)
	return

/atom/proc/hand_h(mob/user as mob)
	return

/atom/proc/hand_p(mob/user as mob)
	return

/atom/proc/hand_a(mob/user as mob)
	return

/atom/proc/hitby(obj/item/weapon/W as obj)
	return

/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/f_print_scanner))
		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("\red [] has been scanned by [] with the []", src, user, W)
	else
		if (!( istype(W, /obj/item/weapon/grab) ) || !(istype(W, /obj/item/weapon/cleaner)))
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O << text("\red <B>[] has been hit by [] with []</B>", src, user, W)
	return

/atom/proc/add_fingerprint(mob/human/M as mob)
	if ((!( istype(M, /mob/human) ) || !( istype(M.primary, /obj/dna) )))
		return 0
	if (!( src.flags ) & 256)
		return
	if (M.gloves)
		return 0
	if (!( src.fingerprints ))
		src.fingerprints = text("[]", md5(M.primary.uni_identity))
	else
		var/list/L = params2list(src.fingerprints)
		L -= md5(M.primary.uni_identity)
		while(L.len >= 3)
			L -= L[1]
		L += md5(M.primary.uni_identity)
		src.fingerprints = list2params(L)
	return

/atom/proc/add_blood(mob/human/M as mob)
	if (!( istype(M, /mob/human) ))
		return 0
	if (!( src.flags ) & 256)
		return
	if (!( src.blood ))
		if (istype(src, /obj/item/weapon))
			var/obj/item/weapon/source2 = src
			source2.icon_old = src.icon
			var/icon/I = new /icon(src.icon, src.icon_state)
			I.Blend(new /icon('blood.dmi', "thisisfuckingstupid"),ICON_ADD)
			I.Blend(new /icon('blood.dmi', "itemblood"),ICON_MULTIPLY)
			I.Blend(new /icon(src.icon, src.icon_state),ICON_UNDERLAY)
			src.icon = I
			src.blood = M.primarynew.uni_identity
			if(M.zombie == 1)
				src.zombieblood = 1
		else if (istype(src, /turf/station))
			var/turf/station/source2 = src
			var/list/objsonturf = range(0,src)
			var/i
			for(i=1, i<=objsonturf.len, i++)
				if(istype(objsonturf[i],/obj/bloodtemplate))
					return
			var/obj/bloodtemplate/this = new /obj/bloodtemplate( source2 )
			this.hulk = M.ishulk
			this.blood = M.primarynew.uni_identity
			if(M.zombie == 1)
				this.zombieblood = 1
			//headsweisbajs

			//old stuff
			//source2.icon_old = src.icon
			//var/icon/I = new /icon(src.icon, src.icon_state)
			//I.Blend(new /icon('blood.dmi', "floorblood"),ICON_OVERLAY)
			//src.icon = I
			//src.blood = M.primarynew.uni_identity
		else if (istype(src, /mob/human))
			src.blood = M.primarynew.uni_identity
		else
			return
	else
		var/list/L = params2list(src.blood)
		L -= M.primarynew.uni_identity
		while(L.len >= 3)
			L -= L[1]
		L += M.primarynew.uni_identity
		src.blood = list2params(L)
	return

/atom/proc/clean_blood()
	if (!( src.flags ) & 256)
		return
	if ( src.blood )
		if (istype (src, /obj/item/weapon))
			var/obj/item/weapon/source2 = src
			source2.blood = null
			var/icon/I = new /icon(source2.icon_old, source2.icon_state)
			source2.icon = I
		else if (istype(src, /turf/station))
			var/obj/item/weapon/source2 = src
			source2.blood = null
			var/icon/I = new /icon(source2.icon_old, source2.icon_state)
			source2.icon = I
	return

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/atom/Click()
	//world.log_attack("atom.Click() on [src] by [usr] : src.type is [src.type]")
	//world << "atom.Click() on [src] by [usr] : src.type is [src.type]"
	return DblClick()

/atom/DblClick()
	if (world.time <= usr:lastDblClick+2)
		//world << "BLOCKED atom.DblClick() on [src] by [usr] : src.type is [src.type]"
		return
	else
		//world << "atom.DblClick() on [src] by [usr] : src.type is [src.type]"
		usr:lastDblClick = world.time

	..()
	if(usr.in_throw_mode)
		return usr.throw_item(src)
	var/obj/item/weapon/W = usr.equipped()
	if ((W == src && usr.stat == 0))
		spawn( 0 )
			W.attack_self(usr)
			//world << "[W].attack_self([usr])"
			return
		return
	if (((!usr.canmove) && (!istype(usr, /mob/ai))) || usr.stat != 0)
		return

	if ((!( src in usr.contents ) && (((!( isturf(src) ) && (!( isturf(src.loc) ) && (src.loc && !( isturf(src.loc.loc) )))) || !( isturf(usr.loc) )) && (src.loc != usr.loc && (!( istype(src, /obj/screen) ) && !( usr.contents.Find(src.loc) ))))))
		return
	var/t5 = ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) || src.loc == usr)
	if (istype(usr, /mob/ai))
		t5 = 1
	if ((istype(src, /obj/item/weapon/organ) && src in usr.contents))
		var/mob/human/H = usr
		usr << "Betchya think you're really smart trying to remove your own body parts aren't ya!"
		if (istype(H, /mob/human))
			if (!( (src == H.l_store || src == H.r_store) ))
				return
		else
			return

	if (((t5 || (W && (W.flags & 16))) && !( istype(src, /obj/screen) )))
		if (usr.next_move < world.time)
			usr.prev_move = usr.next_move
			usr.next_move = world.time + 10
		else
			return
		if ((src.loc && (get_dist(src, usr) < 2 || src.loc == usr.loc)))
			var/direct = get_dir(usr, src)
			var/obj/item/weapon/dummy/D = new /obj/item/weapon/dummy( usr.loc )
			var/ok = 0
			if ( (direct - 1) & direct)
				var/turf/T
				switch(direct)
					if(5.0)
						T = get_step(usr, NORTH)
						if (T.Enter(D, src))
							D.loc = T
							T = src.loc
							if (T.Enter(D, src))
								ok = 1
						else
							T = get_step(usr, EAST)
							if (T.Enter(D, src))
								D.loc = T
								T = src.loc
								if (T.Enter(D, src))
									ok = 1
					if(6.0)
						T = get_step(usr, SOUTH)
						if (T.Enter(D, src))
							D.loc = T
							T = src.loc
							if (T.Enter(D, src))
								ok = 1
						else
							T = get_step(usr, EAST)
							if (T.Enter(D, src))
								D.loc = T
								T = src.loc
								if (T.Enter(D, src))
									ok = 1
					if(9.0)
						T = get_step(usr, NORTH)
						if (T.Enter(D, src))
							D.loc = T
							T = src.loc
							if (T.Enter(D, src))
								ok = 1
						else
							T = get_step(usr, WEST)
							if (T.Enter(D, src))
								D.loc = T
								T = src.loc
								if (T.Enter(D, src))
									ok = 1
					if(10.0)
						T = get_step(usr, SOUTH)
						if (T.Enter(D, src))
							D.loc = T
							T = src.loc
							if (T.Enter(D, src))
								ok = 1
						else
							T = get_step(usr, WEST)
							if (T.Enter(D, src))
								D.loc = T
								T = src.loc
								if (T.Enter(D, src))
									ok = 1
					else
			else
				if (src.loc.Enter(D, src))
					ok = 1
				else
					if ((src.flags & 512 && get_dir(src, usr) & src.dir))
						ok = 1
						if (usr.loc != src.loc)
							for(var/atom/A as mob|obj|turf|area in usr.loc)
								if ((!( A.CheckExit(usr, src.loc) ) && A != usr))
									ok = 0
			//D = null
			del(D)
			if (!( ok ))
				return 0
		if(usr.zombie && istype(src,/mob))
			if (!istype(usr.wear_mask))
				var/mob/m = src
				m.zombie_bit(usr)
		if (!( usr.restrained() ))
			if (W)
				if (t5)
					src.attackby(W, usr)
				if (W)
					W.afterattack(src, usr, (t5 ? 1 : 0))
			else
				if (istype(usr, /mob/human))
					src.attack_hand(usr, usr.hand)
				else
					if (istype(usr, /mob/monkey))
						src.attack_paw(usr, usr.hand)
					else
						if (istype(usr, /mob/ai))
							src.attack_ai(usr, usr.hand)
		else
			if (istype(usr, /mob/human))
				src.hand_h(usr, usr.hand)
			else
				if (istype(usr, /mob/monkey))
					src.hand_p(usr, usr.hand)
				else
					if (istype(usr, /mob/ai))
						src.hand_a(usr, usr.hand)

	else
		if (istype(src, /obj/screen))
			usr.prev_move = usr.next_move
			if (usr.next_move < world.time)
				usr.next_move = world.time + 10
			else
				return
			if (!( usr.restrained() ))
				if ((W && !( istype(src, /obj/screen) )))
					src.attackby(W, usr)

					if (W)
						W.afterattack(src, usr)
				else
					if (istype(usr, /mob/human))
						src.attack_hand(usr, usr.hand)
					else
						if (istype(usr, /mob/monkey))
							src.attack_paw(usr, usr.hand)
			else
				if (istype(usr, /mob/human))
					src.hand_h(usr, usr.hand)
				else
					if (istype(usr, /mob/monkey))
						src.hand_p(usr, usr.hand)
	return


/obj/proc/updateUsrDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_hand(M)
	if (istype(usr, /mob/ai))
		if (!(usr in nearby))
			if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
				src.attack_ai(usr)

/obj/proc/updateDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_hand(M)
	AutoUpdateAI(src)