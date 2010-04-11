/obj/item/weapon/food/bread
	name = "Bread"
	icon_state = "bread"
	var/charges = 1
	var/salami = 0
	var/butter = 0
	var/bread

/obj/item/weapon/food/salami
	name = "salami"
	icon_state = "sal"
/obj/item/weapon/food/
	icon = 'food.dmi'
	var/gotbutter = 0
/obj/item/weapon/food/bread/examine()
	if(!src.salami && !src.butter && !bread)
		usr.show_message(text("A piece of bread with nothing on it.",),1)
		return
	if(src.salami && src.bread && src.butter)
		usr.show_message(text("A piece of bread with butter([]) and salami([]) and bread([])on it.",butter,salami,bread),1)
		return
	if(src.salami && src.butter && !bread)
		usr.show_message(text("A piece of bread with butter([]) and salami([]) on it.",butter,salami),1)
		return
	if(src.butter && !bread && !salami)
		usr.show_message(text("A piece of bread with butter([]) on it.",butter),1)
		return
	if(src.salami && !bread && !butter)
		usr.show_message(text("A piece of bread with salami([]) on it.",salami),1)
		return
	if(src.butter && src.bread && !salami)
		usr.show_message(text("A piece of bread with butter([]) and bread([]) on it.",butter,bread),1)
		return
	if(bread && !salami && !butter)
		usr.show_message(text("A piece of bread with bread([]) on it.",bread),1)
		return

/obj/item/weapon/food/bread/attack(mob/M as mob, mob/user as mob)
	if(M.key == user.key)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] takes a bite off []", user, src), 1)
			src.charges--
			if(src.charges <= 0)
				for(var/mob/X in viewers(M, null))
					X.show_message(text(" [] finishes eating []", user, src), 1)
					del src
			return

	else
		for(var/mob/S in viewers(M, null))
			S.show_message(text("\red [] is forcing [] to take a bite of []", user, M, src), 1)
			src.charges--
			if(src.charges == 0)
				for(var/mob/V in viewers(M, null))
					V.show_message(text("[] finishes eating []", user, src), 1)
					del src
		return

obj/item/weapon/food/bread/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/food/salami))
		src.salami = 1
		overlays += "sal"
		for(var/mob/O in viewers(user, null))
			O.show_message(text("[] puts a slice off [] on [] ", user, W, src), 1)
		del W
	if(istype(W,/obj/item/weapon/food/butterknife))
		var/obj/item/weapon/food/butterknife/k = W
		if(k.gotbutter)
			k.gotbutter = 0
			for(var/mob/O in viewers(user, null))
				O.show_message(text("[] puts some [] on [] ", user, W, src), 1)
			src.butter = 1
			overlays += "butter"
		else
			user << "You need butter first"
	if(istype(W,/obj/item/weapon/food/bread/))
		overlays += "bread"
		for(var/mob/O in viewers(user, null))
			O.show_message(text("[] puts some [] on [] ", user, W, src), 1)
		del W

obj/item/weapon/food/butterpack
	name = "Butter"
	icon = 'food.dmi'
	icon_state = "butterpack"
	var/charges = 5
obj/item/weapon/food/butterknife
	name = "Butter-knife"
	icon = 'food.dmi'
	icon_state = "knife"
	desc = "A crappy wooden butter knife"

obj/item/weapon/food/butterpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/food/butterknife))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("[] gets some butter on [] ", user, W), 1)
		var/obj/item/weapon/food/butterknife/k = W
		k.gotbutter = 1