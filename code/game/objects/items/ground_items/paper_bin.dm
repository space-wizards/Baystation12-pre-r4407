/obj/item/weapon/paper_bin/proc/update()
	src.icon_state = text("paper_bin[]", ((src.amount || locate(/obj/item/weapon/paper, src)) ? "1" : null))
	return

/obj/item/weapon/paper_bin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/paper))
		user.drop_item()
		W.loc = src
	else
		if (istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/T = W
			if ((T.welding && T.weldfuel > 0))
				viewers(user, null) << text("[] burns the paper with the welding tool!", user)
				spawn( 0 )
					src.burn(1800000.0)
					return
		else
			if (istype(W, /obj/item/weapon/igniter))
				viewers(user, null) << text("[] burns the paper with the igniter!", user)
				spawn( 0 )
					src.burn(1800000.0)
					return
	src.update()
	return

/obj/item/weapon/paper_bin/burn(fi_amount)
	flick("paper_binb", src)
	for(var/atom/movable/A as mob|obj in src)
		A.burn(fi_amount)
	if(fi_amount >= 900000.0)
		src.amount = 0
	src.update()
	sleep(11)
	del(src)
	return

/obj/item/weapon/paper_bin/MouseDrop(mob/user as mob)
	if ((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || (get_dist(src, usr) <= 1 || usr.telekinesis == 1))))))
		if (usr.hand)
			if (!( usr.l_hand ))
				spawn( 0 )
					src.attack_hand(usr, 1, 1)
					return
		else
			if (!( usr.r_hand ))
				spawn( 0 )
					src.attack_hand(usr, 0, 1)
					return
	return

/obj/item/weapon/paper_bin/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/paper_bin/attack_hand(mob/user as mob, unused, flag)
	if (flag)
		return ..()
	src.add_fingerprint(user)
	if (locate(/obj/item/weapon/paper, src))
		for(var/obj/item/weapon/paper/P in src)
			if ((usr.hand && !( usr.l_hand )))
				usr.l_hand = P
				P.loc = usr
				P.layer = 52
				P = null
				usr.UpdateClothing()
				break
			else if (!usr.r_hand)
				usr.r_hand = P
				P.loc = usr
				P.layer = 52
				P = null
				usr.UpdateClothing()
				break
	else
		if (src.amount >= 1)
			src.amount--
			new /obj/item/weapon/paper( usr.loc )
	src.update()
	return

/obj/item/weapon/paper_bin/examine()
	set src in oview(1)

	src.amount = round(src.amount)
	var/n = src.amount
	for(var/obj/item/weapon/paper/P in src)
		n++
	if (n <= 0)
		n = 0
		usr << "There are no papers in the bin."
	else
		if (n == 1)
			usr << "There is one paper in the bin."
		else
			usr << text("There are [] papers in the bin.", n)
	return
