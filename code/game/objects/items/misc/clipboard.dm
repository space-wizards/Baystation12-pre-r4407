/obj/item/weapon/clipboard/attack_self(mob/user as mob)
	var/dat = "<B>Clipboard</B><BR>"
	if (src.pen)
		dat += text("<A href='?src=\ref[];pen=1'>Remove Pen</A><BR><HR>", src)
	for(var/obj/item/weapon/paper/P in src)
		dat += text("<A href='?src=\ref[];read=\ref[]'>[]</A> <A href='?src=\ref[];write=\ref[]'>Write</A> <A href='?src=\ref[];remove=\ref[]'>Remove</A><BR>", src, P, P.name, src, P, src, P)
	user << browse(dat, "window=clipboard")
	return

/obj/item/weapon/clipboard/Topic(href, href_list)
	..()
	if ((usr.stat || usr.restrained()))
		return
	if (usr.contents.Find(src))
		usr.machine = src
		if (href_list["pen"])
			if (src.pen)
				if ((usr.hand && !( usr.l_hand )))
					usr.l_hand = src.pen
					src.pen.loc = usr
					src.pen.layer = 52
					src.pen = null
					usr.UpdateClothing()
				else
					if (!( usr.r_hand ))
						usr.r_hand = src.pen
						src.pen.loc = usr
						src.pen.layer = 52
						src.pen = null
						usr.UpdateClothing()
				if (src.pen)
					src.pen.add_fingerprint(usr)
				src.add_fingerprint(usr)
		if (href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if ((P && P.loc == src))
				if ((usr.hand && !( usr.l_hand )))
					usr.l_hand = P
					P.loc = usr
					P.layer = 52
					usr.UpdateClothing()
				else
					if (!( usr.r_hand ))
						usr.r_hand = P
						P.loc = usr
						P.layer = 52
						usr.UpdateClothing()
				P.add_fingerprint(usr)
				src.add_fingerprint(usr)
		if (href_list["write"])
			var/obj/item/P = locate(href_list["write"])
			if ((P && P.loc == src))
				if (istype(usr.r_hand, /obj/item/weapon/pen))
					P.attackby(usr.r_hand, usr)
				else
					if (istype(usr.l_hand, /obj/item/weapon/pen))
						P.attackby(usr.l_hand, usr)
					else
						if (istype(src.pen, /obj/item/weapon/pen))
							P.attackby(src.pen, usr)
			src.add_fingerprint(usr)
		if (href_list["read"])
			var/obj/item/weapon/paper/P = locate(href_list["read"])
			if ((P && P.loc == src))
				if (!( istype(usr, /mob/human) ))
					usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", P.name, stars(P.info)), text("window=[]", P.name))
				else
					usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", P.name, P.info), text("window=[]", P.name))
		if (ismob(src.loc))
			var/mob/M = src.loc
			if (M.machine == src)
				spawn( 0 )
					src.attack_self(M)
					return
	return

/obj/item/weapon/clipboard/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/clipboard/attack_hand(mob/user as mob)

	if ((locate(/obj/item/weapon/paper, src) && (!( user.equipped() ) && (user.l_hand == src || user.r_hand == src))))
		var/obj/item/weapon/paper/P
		for(P in src)
			break
		if (P)
			if (user.hand)
				user.l_hand = P
			else
				user.r_hand = P
			P.loc = user
			P.layer = 52
			P.add_fingerprint(user)
			user.UpdateClothing()
		src.add_fingerprint(user)
	else
		if (user.contents.Find(src))
			spawn( 0 )
				src.attack_self(user)
				return
		else
			return ..()
	return

/obj/item/weapon/clipboard/attackby(obj/item/weapon/P as obj, mob/user as mob)

	if (istype(P, /obj/item/weapon/paper))
		if (src.contents.len < 15)
			user.drop_item()
			P.loc = src
		else
			user << "\blue Not enough space!!!"
	else
		if (istype(P, /obj/item/weapon/pen))
			if (!src.pen)
				user.drop_item()
				P.loc = src
				src.pen = P
		else
			return
	src.update()
	spawn(0)
		attack_self(user)
		return
	return

/obj/item/weapon/clipboard/proc/update()
	src.icon_state = text("clipboard[][]", (locate(/obj/item/weapon/paper, src) ? "1" : "0"), (locate(/obj/item/weapon/pen, src) ? "1" : "0"))
	return
