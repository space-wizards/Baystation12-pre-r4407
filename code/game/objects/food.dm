/obj/item/weapon/bread
	name = "Bread"
	icon = 'food.dmi'
	icon_state = "bread_01"
	var/charges = 1
	var/salami = 0
	var/butter = 0

/obj/item/weapon/bread/examine()
	if(!src.salami && !src.butter)
		usr.show_message(text("A piece of bread with nothing on it.",),1)
		return
	if(src.salami && src.butter)
		usr.show_message(text("A piece of bread with butter and salami on it.",),1)
		return
	if(src.butter == 1)
		usr.show_message(text("A piece of bread with butter on it.",),1)
		return
	if(src.salami == 1)
		usr.show_message(text("A piece of bread with salami on it.",),1)
		return

/obj/item/weapon/bread/attack(mob/M as mob, mob/user as mob)
	if(M.key == user.key)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] takes a bite off []", user, src), 1)
			src.charges--
			if(src.charges == 0)
				for(var/mob/X in viewers(M, null))
					X.show_message(text("\red [] finishes eating []", user, src), 1)
					del src
			return

	else
		for(var/mob/S in viewers(M, null))
			S.show_message(text("\red [] is forcing [] to take a bite of []", user, M, src), 1)
			src.charges--
			if(src.charges == 2)
				src.icon_state = "bread_01"
			if(src.charges == 0)
				for(var/mob/V in viewers(M, null))
					V.show_message(text("\red [] finishes eating []", user, src), 1)
					del src
		return

obj/item/weapon/bread/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/salami))
		src.salami = 1
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] puts a slice off [] on [] ", user, W, src), 1)
		del W