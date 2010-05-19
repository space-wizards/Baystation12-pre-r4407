/obj/machinery/shower
	name = "Decontamination Shower"
	desc = "Use this to remove decontamination."

/obj/machinery/shower/attack_hand(mob/user)
	if(user in view(0,src.loc))
		for(var/obj/item/W in view(0,src.loc))
			if(W.contaminated)
				W.contaminated = 0
		var/obj/effects/water/X = new /obj/effects/water( src.loc )
		X.dir = pick(1,2,4,8)
		spawn( 0 )
			X.Life()
