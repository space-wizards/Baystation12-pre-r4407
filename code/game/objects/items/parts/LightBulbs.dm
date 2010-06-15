
/obj/item/weapon/bulb
	name = "Fluorescent Bulb"
	icon_state = "bulb"
	var/bulbtype = "fluorescent"
	icon = 'items.dmi'
	desc="The bulb appears to be in good condition"
	var/life = 0
	var/bright = 6
	w_class = 4.0 //Yeah, you can really fit a meter-long bulb in your pocket.

/obj/item/weapon/bulb/incandescent
	name = "Incandescent Bulb"
	bulbtype = "incandescent"
	bright = 4
	icon_state = "incandescent"
	w_class = 1.0 //But you can fit a 4" incandescent bulb, that makes sense.

/obj/item/weapon/bulb/incandescent/cfl
	name = "CFL Bulb"
	bright = 6 //fluorescent output in an incandescent form factor!
	//icon_state = "cfl" //Graphics not actually done



/obj/item/weapon/bulb/New()
	..()
	src.life = rand(2400, 40000) //Nanotransen's bulb suppliers have no quality control, who knows how long one'll last.
								 //The values are approximately in seconds
	extext()

/obj/item/weapon/bulb/proc/use()
	if (src.life)
		src.life--
		extext()

/obj/item/weapon/bulb/proc/extext()
	if (!life)
		desc = "The bulb has burned out"
	else if (life <= 2000)
		desc = "The bulb appears to be worn, but working"
