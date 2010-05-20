/obj/item/weapon/food/bread
	name = "Bread"
	icon_state = "bread05"
	var/charges = 3
	var/salami = 0
	var/butter = 0
	var/bread = 0
	var/cheese = 0
	var/foodvalue = 10

/obj/item/weapon/food/salami
	name = "salami"
	icon_state = "sal"

/obj/item/weapon/food/
	icon = 'food.dmi'
	var/gotbutter = 0
	var/gotblood = 0

/obj/item/weapon/food/bread/examine()
	if(!src.salami && !src.butter && !bread)
		usr.show_message(text("A piece of bread with nothing on it.",),1)
		return
	else
		usr.show_message(text("A piece of bread with [][][][] ",(src.salami ? "and salami" : ""), (src.butter ? "and butter" : ""),(src.bread ? "and bread" : ""),(src.cheese ? "and cheese" : ""),),1)
		return

/obj/item/weapon/food/bread/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] takes a bite off []", user, src), 1)
			add_food(user,1,foodvalue)
		src.charges--
		if(src.charges <= 0)
			for(var/mob/X in viewers(M, null))
				X.show_message(text(" [] finishes eating []", user, src), 1)
			del src
		return

	else
		for(var/mob/S in viewers(M, null))
			S.show_message(text("\red [] is forcing [] to take a bite of []", user, M, src), 1)
			add_food(M,1,foodvalue)
		src.charges--
		if(src.charges == 0)
			for(var/mob/V in viewers(M, null))
				V.show_message(text("[] finishes eating []", M, src), 1)
			del src
		return

obj/item/weapon/food/bread/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/food/salami))
		src.salami++
		src.name = "sandwich"
		src.foodvalue += 10
		overlays += "sals"
		for(var/mob/O in viewers(user, null))
			O.show_message(text("[] puts a slice off [] on [] ", user, W, src), 1)
		del W
	if(istype(W,/obj/item/weapon/food/butterknife))
		var/obj/item/weapon/food/butterknife/k = W
		if(k.gotbutter)
			k.gotbutter = 0
			for(var/mob/O in viewers(user, null))
				O.show_message(text("[] puts some butter on [] ", user,src), 1)
			src.butter++
			src.foodvalue += 5
			src.name = "sandwich"
			overlays += "butter"
			W.overlays = null
		else
			user << "You need butter first"
	if(istype(W,/obj/item/weapon/food/bread/))
		overlays += "bread06"
		src.bread++
		src.foodvalue += 10
		src.name = "sandwich"
		for(var/mob/O in viewers(user, null))
			O.show_message(text("[] puts some [] on [] ", user, W, src), 1)
		del W
	if(istype(W,/obj/item/weapon/food/cheese/))
		overlays += "cheese1"
		src.cheese++
		src.foodvalue += 10
		src.name = "sandwich"
		for(var/mob/O in viewers(user, null))
			O.show_message(text("[] puts some [] on [] ", user, W, src), 1)
		del W

obj/item/weapon/food/meat
	name = "Meat Stick"
	icon = 'food.dmi'
	icon_state = "meat"
	var/charges = 3

obj/item/weapon/food/cheese
	name = "Cheese"
	icon = 'food.dmi'
	icon_state = "cheese2"
	var/charges = 3

/obj/item/weapon/food/meat/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] takes a bite off []", user, src), 1)
			add_food(user,1,20)
		src.charges--
		if(src.charges <= 0)
			for(var/mob/X in viewers(M, null))
				X.show_message(text(" [] finishes eating []", M, src), 1)
			del src
		return

	else
		for(var/mob/S in viewers(M, null))
			S.show_message(text("\red [] is forcing [] to take a bite of []", user, M, src), 1)
			add_food(M,1,20)
		src.charges--
		if(src.charges == 0)
			for(var/mob/V in viewers(M, null))
				V.show_message(text("[] finishes eating []", M, src), 1)
			del src
		return

obj/item/weapon/food/plump
	name = "Plump Helmet"
	icon = 'food.dmi'
	icon_state = "plump"
	desc = "A rare delicacy from a distant planet!"
	var/charges = 3


/obj/item/weapon/food/plump/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] takes a bite off []", user, src), 1)
			add_food(user,1,20)
		src.charges--
		if(src.charges <= 0)
			for(var/mob/X in viewers(M, null))
				X.show_message(text(" [] finishes eating []", M, src), 1)
			del src
		return

	else
		for(var/mob/S in viewers(M, null))
			S.show_message(text("\red [] is forcing [] to take a bite of []", user, M, src), 1)
			add_food(M,1,20)
		src.charges--
		if(src.charges == 0)
			for(var/mob/V in viewers(M, null))
				V.show_message(text("[] finishes eating []", M, src), 1)
			del src
		return
obj/item/weapon/food/butterpack
	name = "Butter"
	icon = 'food.dmi'
	icon_state = "butterpack"
	desc = "I can't believe it's not butter."
	var/charges = 5

obj/item/weapon/food/butterknife
	name = "Butter-knife"
	icon = 'food.dmi'
	icon_state = "knife"
	s_istate = "s_knife"
	desc = "A crappy wooden butter knife"

obj/item/weapon/food/butterpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/food/butterknife))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("[] gets some butter on [] ", user, W), 1)
		var/obj/item/weapon/food/butterknife/k = W
		k.gotbutter = 1
		W.overlays += "butter2"
obj/item/weapon/food/waterbottle
	name = "Space Mountain Mineral Water"
	icon = 'food.dmi'
	icon_state = "bottle4"
	s_istate = "waterbottle"
	desc = "Enjoy Space Mountain Mineral Water (the industry leader in bottle water) at home or in the office. Space Mountain is a pure mineral water that conforms to W.H.O Guidelines and is ideal for everyone at any time."
	var/ammount = 5
obj/item/weapon/food/waterbottle/proc/updateicon()
	if(ammount == 5)
		icon_state = "bottle4"
		return
	icon_state = "bottle[ammount]"
/obj/item/weapon/food/waterbottle/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		if(src.ammount)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red [] takes a sip off []", user, src), 1)
			add_food(user,0,50)
			src.ammount--
			src.updateicon()
		else
			user << "You sadly frown as you shake the last drop from the bottle"
	else
		if(src.ammount)
			for(var/mob/S in viewers(M, null))
				S.show_message(text("\red [] is forcing [] to take a sip of []", user, M, src), 1)
			add_food(M,0,50)
			src.ammount--
			src.updateicon()
		else
			for(var/mob/S in viewers(user, null))
				S.show_message(text("\red [] sadly frown as you realise that bottle is empty",user), 1)
			user << "You sadly frown as you realise that bottle is empty"
/obj/item/weapon/food/waterbottle/examine()
	if(src.ammount)
		usr << "It's a bottle filled with water it's about [ammount]/5 full"
		usr << "The label says <br> [src.desc]"
	else
		usr << "It's an empty bottle"
		usr << "The label says <br> [src.desc]"